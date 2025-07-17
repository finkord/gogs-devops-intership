# ================================
#  Gogs DevOps Makefile (Windows)
# ================================

# ===========
# Parameters
# ===========

# Docker image metadata
# IMAGE_NAME := gogs-dev
IMAGE_NAME := gogs/test

# Context directory for docker build
CONTEXT_DIR := ./gogs.io

# Determine current timestamp and current Git branch (for Windows PowerShell)
# These variables are evaluated at parse-time
TIMESTAMP := $(shell powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'")
BRANCH    := $(shell powershell -NoProfile -Command "try { (git -C ./gogs.io rev-parse --abbrev-ref HEAD) } catch { 'unknown' }")
TAG       := dev_$(BRANCH)_$(TIMESTAMP)

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
	@echo "  print-tag   Print generated image tag"
	@echo "  run         Start docker-compose services"
	@echo "  stop        Stop docker-compose services"
	@echo "  status      Show docker status"
	@echo "  vbox        Start VM with Vagrant"
	@echo "  d-vbox      Destroy Vagrant VM"
	@echo ""

# ---------------------------------------
# Docker: Build image with versioned tag
# ---------------------------------------
build:
	docker build -t $(IMAGE_NAME):$(TAG) -t $(IMAGE_NAME):latest ./gogs.io

# ----------------------------------------
# Print generated image tag (for logging)
# ----------------------------------------
print-tag:
	@echo $(IMAGE_NAME):$(TAG)

# ----------------------------------------
# Docker Compose: Start services
# ----------------------------------------
run:
	docker compose up -d

# ----------------------------------------
# Docker Compose: Stop and remove services
# ----------------------------------------
stop:
	docker compose down

# ----------------------------------------
# Docker Compose: Print status of containers
# ----------------------------------------
status:
	@echo Docker containers:
	@docker ps -a
	@echo

# ----------------------------------------
# Vagrant: Start VMs (default provider)
# ----------------------------------------
vbox:
	vagrant up

# ----------------------------------------
# Vagrant: Destroy VMs forcefully
# ----------------------------------------
d-vbox:
	vagrant destroy -f

