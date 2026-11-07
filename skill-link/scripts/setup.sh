#!/usr/bin/env bash
set -euo pipefail

_src="${BASH_SOURCE[0]}"
while [[ -L "$_src" ]]; do
  _dir=$(cd -P "$(dirname "$_src")" && pwd)
  _src=$(readlink "$_src")
  [[ $_src != /* ]] && _src="$_dir/$_src"
done
SCRIPT_DIR=$(cd -P "$(dirname "$_src")" && pwd)
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

[[ $# -ge 1 ]] || die "Usage: skill-setup <workspace-root>"

ROOT=$(cd "$1" && pwd)

[[ -d "$ROOT/me" ]] || die "Expected me/ under workspace root: $ROOT"

mkdir -p "$ROOT/vendor"
printf '%s\n' "$ROOT" >"$CONFIG_FILE"

echo "Library: $ROOT"
echo "Config:  $CONFIG_FILE"
