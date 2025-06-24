# Makefile
SHELL := cmd.exe

# LINUX
# TIMESTAMP := $(shell date +"%Y%m%d_%H%M%S")
# BRANCH := $(shell git -C ./gogs.io rev-parse --abbrev-ref HEAD 2>NUL || echo unknown)

# WINDOWS
TIMESTAMP := $(shell powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'")
BRANCH := $(shell powershell -NoProfile -Command "try { (git -C ./gogs.io rev-parse --abbrev-ref HEAD) } catch { 'unknown' }")

IMAGE_NAME := gogs-dev
TAG := dev_$(BRANCH)_$(TIMESTAMP)

build:
	docker build -t $(IMAGE_NAME):$(TAG) -t $(IMAGE_NAME):latest ./gogs.io

print-tag:
	@echo $(IMAGE_NAME):$(TAG)

run: 
	docker compose up -d 
	
stop:
	docker compose down