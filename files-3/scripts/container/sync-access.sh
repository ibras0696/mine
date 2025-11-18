#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
OPS_LIST="${OPS:-}"
WHITELIST_PLAYERS="${WHITELIST:-}"
SYNC_OPS="${SYNC_OPS_FROM_ENV:-true}"
SYNC_WHITELIST="${SYNC_WHITELIST_FROM_ENV:-true}"

log() {
  echo "[access-sync] $1"
}

if [[ "${SYNC_OPS,,}" == "true" && -n "${OPS_LIST}" ]]; then
  if [[ -f "${DATA_DIR}/ops.json" ]]; then
    rm -f "${DATA_DIR}/ops.json"
    log "Удаляю ops.json, чтобы значения из OPS были пересозданы при запуске."
  else
    log "ops.json отсутствует — значения OPS будут созданы контейнером."
  fi
fi

if [[ "${SYNC_WHITELIST,,}" == "true" && -n "${WHITELIST_PLAYERS}" ]]; then
  if [[ -f "${DATA_DIR}/whitelist.json" ]]; then
    rm -f "${DATA_DIR}/whitelist.json"
    log "Удаляю whitelist.json, чтобы список из WHITELIST был пересоздан."
  else
    log "whitelist.json отсутствует — список WHITELIST будет создан контейнером."
  fi
fi
