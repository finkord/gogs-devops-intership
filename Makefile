# ================================
#  Gogs DevOps Makefile (Windows)
# ================================


TIMESTAMP := $(shell powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmm'")
BRANCH    := $(shell powershell -NoProfile -Command "try { (git -C ./gogs.io rev-parse --abbrev-ref HEAD) } catch { 'unknown' }")
TAG       := $(BRANCH)_$(TIMESTAMP)

REPOSITORY_NAME := finkord/gogs-dev
CONTEXT_DIR := ./gogs.io

IMAGE_NAME := $(REPOSITORY_NAME):$(TAG)

# ===========
#  Commands
# ===========

# ---------------------------------------
# Makefile: Display available Make targets
# ---------------------------------------
help:
	@echo ""
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@echo "  help        Show this message"
	@echo "  build       Build docker image with tag '$(TAG)'"
	@echo "  push        Push docker image to repository"
	@echo "  print-tag   Print generated image tag"
	@echo ""

# ---------------------------------------
# Docker: Build image with versioned tag
# ---------------------------------------
build:
	docker build -t $(IMAGE_NAME) -t $(REPOSITORY_NAME):latest ./gogs.io

# ----------------------------------------
# Push docker image to repository
# ----------------------------------------
push:
	docker push $(REPOSITORY_NAME):latest

# ----------------------------------------
# Print generated image tag (for logging)
# ----------------------------------------
print-tag:
	@echo $(IMAGE_NAME)