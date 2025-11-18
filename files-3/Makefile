PROJECT_NAME ?= mc-forge
DOCKER_COMPOSE ?= docker compose
SERVICE ?= mc
ENV_FILE ?= .env
DATA_DIR ?= data
CMD ?=

.PHONY: help configure doctor build up down restart stop start logs status pull console shell clean

help:
	@echo "Команды:"
	@echo "  make configure        - подготовить каталоги data/* и .env"
	@echo "  make doctor           - проверить наличие docker/make"
	@echo "  make build            - собрать образ mc-forge"
	@echo "  make up / make down   - запустить или остановить стек"
	@echo "  make logs             - смотреть логи"
	@echo "  make console CMD=\"say hi\" - отправить команду на сервер"

configure:
	@mkdir -p $(DATA_DIR)/my_world $(DATA_DIR)/mods $(DATA_DIR)/config $(DATA_DIR)/logs
	@if [ ! -f $(ENV_FILE) ]; then cp .env.example $(ENV_FILE); echo "Создан $(ENV_FILE)."; fi
	@touch $(DATA_DIR)/my_world/.gitkeep $(DATA_DIR)/mods/.gitkeep $(DATA_DIR)/config/.gitkeep $(DATA_DIR)/logs/.gitkeep
	@echo "Каталоги и $(ENV_FILE) готовы."

doctor:
	@command -v docker >/dev/null 2>&1 || (echo "docker не установлен" && exit 1)
	@$(DOCKER_COMPOSE) version >/dev/null 2>&1 || (echo "docker compose не найден" && exit 1)
	@command -v make >/dev/null 2>&1 || (echo "make не найден" && exit 1)
	@echo "Все зависимости на месте."

build:
	$(DOCKER_COMPOSE) build --pull

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

console:
	@if [ -z "$(CMD)" ]; then echo "Укажи команду: make console CMD=\"say hi\"" && exit 1; fi
	$(DOCKER_COMPOSE) exec $(SERVICE) mc-send-to-console "$(CMD)"

shell:
	$(DOCKER_COMPOSE) exec -it $(SERVICE) bash

clean:
	$(DOCKER_COMPOSE) down -v
