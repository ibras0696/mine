#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"

echo "[mc-tools] Проверяем каталоги в ${DATA_DIR}"

create_dir() {
  local dir="$1"
  if [ ! -d "${DATA_DIR}/${dir}" ]; then
    mkdir -p "${DATA_DIR}/${dir}"
    echo "  • создаю ${dir}"
  else
    echo "  • ${dir} уже существует"
  fi
}

create_dir "my_world"
create_dir "mods"
create_dir "config"
create_dir "logs"

echo "[mc-tools] Готово. Можно запускать сервер."
