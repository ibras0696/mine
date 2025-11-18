#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_CMD=${COMPOSE_CMD:-docker compose}
SERVICE_NAME=${SERVICE_NAME:-mc}
CONSOLE_UID=${CONSOLE_UID:-1000}

if [[ $# -eq 0 ]]; then
  echo "Использование: scripts/mc-console.sh \"команда\""
  exit 1
fi

CMD="$*"
cd "${PROJECT_DIR}"
${COMPOSE_CMD} exec --user "${CONSOLE_UID}" "${SERVICE_NAME}" mc-send-to-console "${CMD}"
