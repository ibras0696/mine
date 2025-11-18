#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

log() {
  echo ""
  echo "==> $1"
}

log "Обновляю пакеты Ubuntu 24.04 LTS"
$SUDO apt update -y
$SUDO apt upgrade -y

log "Устанавливаю зависимости (curl, ca-certificates, git, make, ufw)"
$SUDO apt install -y ca-certificates curl gnupg git make ufw

if ! command -v docker >/dev/null 2>&1; then
  log "Настраиваю официальный репозиторий Docker"
  $SUDO install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | $SUDO gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  $SUDO chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
    $SUDO tee /etc/apt/sources.list.d/docker.list >/dev/null
fi

log "Ставлю Docker Engine и Compose plugin"
$SUDO apt update -y
$SUDO apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

log "Включаю и проверяю службу docker"
$SUDO systemctl enable docker
$SUDO systemctl restart docker
$SUDO systemctl status docker --no-pager

log "Добавляю пользователя ${USER} в группу docker"
$SUDO usermod -aG docker "${USER}"

echo ""
echo "Скрипт завершён. Выйди из SSH-сессии и войди снова, чтобы группа docker применилась."
