#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

VENV_DIR="${VENV_DIR:-.venv}"
VENV_PYTHON="$VENV_DIR/bin/python"
VENV_PIP="$VENV_DIR/bin/pip"
DEPS_MARKER="$VENV_DIR/.requirements-installed"

if [ ! -x "$VENV_PYTHON" ]; then
  python3 -m venv "$VENV_DIR"
fi

if [ ! -f "$DEPS_MARKER" ] || [ requirements.txt -nt "$DEPS_MARKER" ]; then
  "$VENV_PIP" install -q -r requirements.txt
  touch "$DEPS_MARKER"
fi

export HOST="${HOST:-0.0.0.0}"
export PORT="${PORT:-8765}"
export PYTHONUNBUFFERED=1

# A previous managed restart can briefly leave the old Uvicorn process behind.
# Only clear listeners that belong to this app and this configured port.
if command -v lsof >/dev/null 2>&1; then
  while read -r pid; do
    [ -z "$pid" ] && continue
    command_line="$(ps -p "$pid" -o args= 2>/dev/null || true)"
    case "$command_line" in
      *"$PWD"*"server.py"*)
        kill "$pid" 2>/dev/null || true
        ;;
    esac
  done < <(lsof -t -iTCP:"$PORT" -sTCP:LISTEN 2>/dev/null || true)
  sleep 1
fi

exec "$VENV_PYTHON" server.py