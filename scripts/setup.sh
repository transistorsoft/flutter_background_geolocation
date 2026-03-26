#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." &>/dev/null && pwd)"

cd "$REPO_ROOT"

echo "▶ Configuring git hooks path → scripts/hooks"
git config core.hooksPath scripts/hooks

echo "✅ Setup complete."
