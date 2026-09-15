#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for MultiAgent-Werewolf.
# Installs backend (Python via uv) and frontend (npm) dependencies.
set -euo pipefail

cd "$(dirname "$0")/.."

# 1. Install uv (Python dependency manager) if it is not already available.
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
export PATH="$HOME/.local/bin:$PATH"

# 2. Backend dependencies (runtime + dev + test groups), pinned to uv.lock.
uv sync --frozen --group dev --group test

# 3. Local env file for development. Contains placeholders only; real LLM API
#    keys are optional and only needed for live LLM games (demo/replay work without them).
if [ ! -f .env ]; then
  cp .env.example .env
fi

# 4. Frontend dependencies.
cd frontend
npm install
