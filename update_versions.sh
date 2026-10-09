#!/usr/bin/env bash

# Script: update_versions.sh
# Purpose: Update all Terraform modules and environments with required provider and terraform version constraints.
# Usage: ./update_versions.sh [options]

set -euo pipefail

# Default configuration values
DEFAULT_AWS_VERSION="~> 5.3"
DEFAULT_TF_VERSION=">= 1.5.0"
AWS_VERSION="${DEFAULT_AWS_VERSION}"
TF_VERSION="${DEFAULT_TF_VERSION}"
CLEAN_LOCKS=false
DRY_RUN=false
RUN_FMT=true

# Parse command line arguments
usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --aws-version <ver>      Set AWS provider version constraint (default: "$DEFAULT_AWS_VERSION")
  --tf-version <ver>       Set Terraform required_version constraint (default: "$DEFAULT_TF_VERSION")
  --no-tf-version          Do not include required_version in generated versions.tf
  --clean-locks            Remove existing .terraform.lock.hcl and .terraform directories
  --dry-run                Print actions without modifying files
  --no-fmt                 Do not run terraform fmt after updating files
  -h, --help               Show this help message
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --aws-version)
            AWS_VERSION="$2"
            shift 2
            ;;
        --tf-version)
            TF_VERSION="$2"
            shift 2
            ;;
        --no-tf-version)
            TF_VERSION=""
            shift
            ;;
        --clean-locks)
            CLEAN_LOCKS=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --no-fmt)
            RUN_FMT=false
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage
            ;;
    esac
done

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Discover all Terraform directories under modules and envs
find_tf_dirs() {
    local base_dir="$1"
    if [[ -d "$base_dir" ]]; then
        find "$base_dir" -not -path '*/.*' -name "*.tf" -exec dirname {} + | sort -u
    fi
}

echo "=== Terraform Version Update Utility ==="
echo "Target AWS provider constraint: ${AWS_VERSION}"
if [[ -n "${TF_VERSION}" ]]; then
    echo "Target Terraform required_version: ${TF_VERSION}"
else
    echo "Target Terraform required_version: [omitted]"
fi
echo "Clean lockfiles: ${CLEAN_LOCKS}"
echo "Dry run: ${DRY_RUN}"
echo "========================================="

# Collect target directories
MODULE_DIRS=$(find_tf_dirs "${REPO_ROOT}/modules")
ENV_DIRS=$(find_tf_dirs "${REPO_ROOT}/envs")

ALL_DIRS=()
while IFS= read -r dir; do
    [[ -n "$dir" ]] && ALL_DIRS+=("$dir")
done <<< "${MODULE_DIRS}"$'\n'"${ENV_DIRS}"

if [[ ${#ALL_DIRS[@]} -eq 0 ]]; then
    echo "No Terraform directories found."
    exit 0
fi

echo "Found ${#ALL_DIRS[@]} Terraform directories to process."

# Generate versions.tf content
build_versions_content() {
    local content="terraform {\n"
    if [[ -n "${TF_VERSION}" ]]; then
        content+="  required_version = \"${TF_VERSION}\"\n\n"
    fi
    content+="  required_providers {\n"
    content+="    aws = {\n"
    content+="      source  = \"hashicorp/aws\"\n"
    content+="      version = \"${AWS_VERSION}\"\n"
    content+="    }\n"
    content+="  }\n"
    content+="}\n"
    printf "%b" "$content"
}

UPDATED_COUNT=0
LOCKS_CLEANED_COUNT=0

for dir in "${ALL_DIRS[@]}"; do
    rel_path="${dir#"${REPO_ROOT}/"}"
    versions_file="${dir}/versions.tf"

    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] Would update: ${rel_path}/versions.tf"
    else
        echo "[UPDATE] ${rel_path}/versions.tf"
        build_versions_content > "${versions_file}"
        UPDATED_COUNT=$((UPDATED_COUNT + 1))
    fi

    if [[ "$CLEAN_LOCKS" == true ]]; then
        lock_file="${dir}/.terraform.lock.hcl"
        tf_dir="${dir}/.terraform"
        if [[ -f "$lock_file" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "[DRY-RUN] Would remove: ${rel_path}/.terraform.lock.hcl"
            else
                rm -f "$lock_file"
                LOCKS_CLEANED_COUNT=$((LOCKS_CLEANED_COUNT + 1))
            fi
        fi
        if [[ -d "$tf_dir" ]]; then
            if [[ "$DRY_RUN" == true ]]; then
                echo "[DRY-RUN] Would remove: ${rel_path}/.terraform"
            else
                rm -rf "$tf_dir"
            fi
        fi
    fi
done

if [[ "$RUN_FMT" == true && "$DRY_RUN" == false ]]; then
    if command -v terraform >/dev/null 2>&1; then
        echo "Running terraform fmt across updated directories..."
        terraform fmt -recursive "${REPO_ROOT}/modules" >/dev/null 2>&1 || true
        terraform fmt -recursive "${REPO_ROOT}/envs" >/dev/null 2>&1 || true
    fi
fi

echo "========================================="
echo "Update complete."
echo "Updated configurations: ${UPDATED_COUNT}"
if [[ "$CLEAN_LOCKS" == true ]]; then
    echo "Removed lockfiles: ${LOCKS_CLEANED_COUNT}"
fi
echo "========================================="
