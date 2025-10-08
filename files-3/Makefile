PROJECT_NAME ?= mc-forge
DOCKER_COMPOSE ?= docker compose
SERVICE ?= mc
ENV_FILE ?= .env

.PHONY: help setup up down restart stop start logs tail pull status shell

help:
	@echo "Available targets:"
	@echo "  make setup   - copy .env.example to .env (if missing) and create data directories"
	@echo "  make up       - start the Minecraft server stack in detached mode"
	@echo "  make down     - stop and remove the stack"
	@echo "  make restart  - restart the Minecraft server container"
	@echo "  make stop     - stop the stack without removing volumes"
	@echo "  make start    - start an already created stack"
	@echo "  make logs     - follow server logs"
	@echo "  make pull     - pull freshest container image"
	@echo "  make status   - show container status"

setup:
	@mkdir -p data/my_world data/mods data/config data/logs
	@if [ ! -f $(ENV_FILE) ]; then cp .env.example $(ENV_FILE); fi
	@touch data/my_world/.gitkeep data/mods/.gitkeep data/config/.gitkeep data/logs/.gitkeep
	@echo "Setup complete. Review $(ENV_FILE) before running the server."

up:
	$(DOCKER_COMPOSE) up -d

pull:
	$(DOCKER_COMPOSE) pull

restart:
	$(DOCKER_COMPOSE) restart $(SERVICE)

stop:
	$(DOCKER_COMPOSE) stop

start:
	$(DOCKER_COMPOSE) start

down:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f $(SERVICE)

status:
	$(DOCKER_COMPOSE) ps
