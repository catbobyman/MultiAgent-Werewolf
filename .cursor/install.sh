#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for MultiAgent-Werewolf.
# Installs the uv toolchain (if missing) and syncs project dependencies.
# Python 3.10 is provisioned automatically by uv from .python-version + uv.lock.
set -euo pipefail

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
