#!/usr/bin/env bash
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Использование: console-wrapper.sh \"команда\""
  exit 1
fi

if ! command -v mc-send-to-console >/dev/null 2>&1; then
  echo "mc-send-to-console недоступна внутри контейнера."
  exit 2
fi

CMD="$*"
mc-send-to-console "${CMD}"
