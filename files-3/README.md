# Minecraft Forge 1.20.1 — Docker Compose (до 5 игроков, без бэкапов)

Готовый стек, чтобы поднять модовый сервер Minecraft Forge 1.20.1 на VPS за пару команд:
- Оптимизирован под небольшую команду (до 5 игроков).
- Без контейнеров бэкапов (как просили).
- По умолчанию доступ — через VPN (ZeroTier) или вручную открыть порт 25565.
- Запуск через Docker Compose, все настраивается через .env и папку `data/` (мир, моды, конфиги).
- В комплекте Makefile с командами `make setup`, `make up`, `make logs` и др.
- Подробное руководство по эксплуатации: см. `docs/USAGE.md`.
- Инструкция по Radmin VPN (альтернатива ZeroTier): см. `docs/vpn/RADMIN.md`.
- Администрирование (читы, OP-права): см. `docs/ADMIN.md`.
- Расширенные настройки мира и сервера: см. `docs/SERVER_SETTINGS.md`.

Содержание:
- 1) Минимальные требования
- 2) Подготовка VPS (Ubuntu 22.04)
- 3) Клонирование репозитория и структура проекта
- 4) Подготовка мира и модов
- 5) Настройка через .env
- 6) Запуск и логи
- 7) VPN-доступ через ZeroTier (рекомендуется)
- 8) Открытие порта наружу (альтернатива VPN)
- 9) Управление и обновления
- 10) Тюнинг под 5 игроков
- 11) Частые проблемы и решения

---

## 1) Минимальные требования

- VPS: 2 vCPU, 4–6 ГБ RAM, SSD 20+ ГБ (зависит от модпака/мира).
  - Для до ~30 модов и 5 игроков часто хватает 4 ГБ.
  - Если модов больше или сборка тяжелая — подними до 6–8 ГБ.
- ОС: Ubuntu 22.04 LTS (рекомендовано).
- Установленный Docker и Docker Compose (см. ниже).
- Установленный GNU Make (используется для автоматизации запуска).
- На клиентах — тот же Forge 1.20.1 и те же версии модов.

---

## 2) Подготовка VPS (Ubuntu 22.04)

Подключись по SSH и выполни:

```bash
# Обновления и UFW
sudo apt update && sudo apt -y upgrade
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp       # оставить SSH доступ
sudo ufw enable
sudo ufw status

# Установка Docker и Compose
sudo apt install -y ca-certificates curl gnupg make
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker

# Разрешить текущему пользователю работать с docker без sudo
sudo usermod -aG docker $USER
newgrp docker
docker --version
docker compose version
```

Если команды `docker` или `docker compose` не находятся:

```bash
which docker
which docker-compose
```

- При отсутствии бинаря повторите установку пакетов `docker-ce` и `docker-compose-plugin`.
- Убедитесь, что вы заново вошли в систему (logout/login) после добавления в группу `docker`.
- На старых системах может потребоваться пакет `docker-compose` (старая версия). Рекомендуется использовать plugin.
```

---

## 3) Клонирование репозитория и структура проекта

```bash
# Выбери папку, где будет проект (пример /root)
cd ~
git clone <URL_ЭТОГО_РЕПОЗИТОРИЯ> mc-forge
cd mc-forge
```

Структура (создается автоматически командой `make setup`):
```
mc-forge/
  README.md
  docker-compose.yml
  .env.example
  Makefile
  data/
    my_world/         # сюда положи свой мир
    mods/             # сюда положи .jar моды
    config/           # (опционально) конфиги модов
    logs/             # создастся автоматически
```

---

## 4) Подготовка мира и модов

- Папка мира:
  - Если у тебя уже есть мир, положи его в `./data/my_world` (или другое имя — укажешь в .env).
  - Важно: файлы `level.dat` и папка `region/` должны лежать прямо в корне выбранной папки. Не помещай мир во вложенную подпапку, иначе сервер создаст новый мир.
  - Если папки мира нет — сервер сам создаст новый при первом запуске.

- Моды:
  - Положи .jar-файлы серверных модов в `./data/mods/`.
  - Важно: у клиентов должны быть те же моды и версии. Чисто клиентские моды (HUD/миникарта) не клади на сервер.

- Конфиги модов (по необходимости) положи в `./data/config/`.

---

## 5) Настройка через .env

Быстрый способ — выполнить `make setup`, он создаст папки в `data/` и скопирует `.env.example` в `.env` (если файла ещё нет).

Вручную то же самое делается так:
```bash
cp .env.example .env
nano .env
```

Минимум, что стоит проверить:
- `MEMORY` — 4G (или 6G для тяжелых сборок).
- `LEVEL` — имя папки мира (по умолчанию `my_world`).
- `MAX_PLAYERS=5` — как просили.
- `ONLINE_MODE=TRUE` — оставь TRUE для лицензионных аккаунтов.
  - Для оффлайн-лаунчеров поставь `FALSE`, но включи whitelist, иначе любой сможет зайти.
- `VIEW_DISTANCE` и `SIMULATION_DISTANCE` — 8 для снижения нагрузки.

---

## 6) Запуск и логи

```bash
# Скачать/обновить образы и запустить
make pull
make up

# Логи сервера (следить)
make logs
# Жди строку "Done (xx.xxxs)! For help, type "help""
```

Остановить/запустить позже:
```bash
make stop
make start
```

Полный перезапуск:
```bash
make down
make up
```

---

## 7) VPN-доступ через ZeroTier (рекомендуется)

Так безопаснее: порт не торчит наружу, игроки заходят по VPN-IP.

Шаги:
```bash
# Установка ZeroTier на сервер (ХОСТ, не в контейнер)
curl -s https://install.zerotier.com | sudo bash

# Присоединиться к своей сети (создай сеть на https://my.zerotier.com)
sudo zerotier-cli join <YourNetworkID>

# В веб-панели ZeroTier: Members -> поставь галочку Authorize для сервера
# Узнать VPN IP сервера:
zerotier-cli listnetworks
ip addr show zt*
```

Ограничь доступ к Minecraft-порту только через VPN интерфейс:
```bash
# Разрешить на интерфейсах ZeroTier (zt+), наружу не открывать
sudo ufw allow in on zt+ to any port 25565 proto tcp
```

Игроки:
- Ставят ZeroTier One, Join к той же сети, ты их Authorize.
- Подключаются по VPN_IP_СЕРВЕРА:25565.

---

## 8) Открытие порта наружу (альтернатива VPN)

Если хочешь без VPN (не рекомендуется):
```bash
sudo ufw allow 25565/tcp
sudo ufw status
```
Потом игроки подключаются по публичному IP: `ПУБЛИЧНЫЙ_IP:25565`.

---

## 9) Управление и обновления

- Обновить образ и перезапустить:
  ```bash
  make pull
  make up
  ```
- Добавить/обновить моды:
  - Скопируй .jar в `./data/mods/`.
  - Перезапусти сервер: `make restart`.
- Изменить базовые параметры:
  - Поправь `.env` (см. список переменных), затем `make up`.
- Посмотреть статус контейнеров: `make status`.

---

## 10) Тюнинг под 5 игроков (уже учтено по умолчанию)

- `MEMORY=4G` (в .env). Если начнутся лаги — поставь `6G`.
- `MAX_PLAYERS=5`.
- `VIEW_DISTANCE=8`, `SIMULATION_DISTANCE=8` — меньше нагрузка на CPU.
- Можно включить whitelist для приватности (см. .env примеры).

---

## 11) Частые проблемы и решения

- Несовпадение модов:
  - Проверь, что версии на клиенте и сервере совпадают.
  - Иногда нужны одинаковые конфиги из `data/config`.
- Порт занят:
  - `docker ps` — нет ли второго контейнера на 25565.
  - UFW/файрволл провайдера — не блокируют ли доступ.
- Мир не тот:
  - Убедись, что `LEVEL` в .env совпадает с именем папки мира (Linux — чувствителен к регистру).
- Не запускается с 4G:
  - Подними `MEMORY` до `6G` и дай процессору 2 vCPU+.
  - Ошибка `Native memory allocation (mmap)` означает, что хосту не хватает RAM: снизь `MEMORY` в `.env` (например, до `3G`/`2G`) или добавь swap (`sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile`).

Удачи! Если хочешь — могу подставить твое имя мира/список модов в .env и прислать готовый архив репозитория.