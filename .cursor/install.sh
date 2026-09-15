#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for MultiAgent-Werewolf.
# Installs the uv toolchain (if missing) and syncs project dependencies.
# Python 3.10 is provisioned automatically by uv from .python-version + uv.lock.
set -euo pipefail

# Resolve the repository root from this script's own location so the command
# works regardless of the caller's current working directory (the Cloud Agent
# workspace may span multiple repos, so install does not run from the repo root).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

# 1. Install uv (Python project/package manager) if it is not already available.
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# The uv installer drops binaries in ~/.local/bin; make sure they are on PATH
# for the remainder of this script regardless of shell profile state.
export PATH="$HOME/.local/bin:$PATH"

# 2. Create the virtualenv and install all dependency groups (runtime + dev +
#    test + docs) from the committed uv.lock. Re-running is a fast no-op.
uv sync --all-groups
