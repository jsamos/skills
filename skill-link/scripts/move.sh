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

name="${1:-}"
validate_name "$name"

library=$(read_library)
src="${HOME}/.agents/skills/${name}"
dest="${library}/vendor/${name}"

if [[ ! -e "$src" && ! -L "$src" ]]; then
  die "Not found in staging: $src"
fi

if [[ -e "$dest" || -L "$dest" ]]; then
  die "Already exists in vendor: $dest"
fi

mkdir -p "${library}/vendor"

if [[ -L "$src" ]]; then
  real=$(realpath_of "$src")
  case "$real" in
    "$library"/*)
      die "Already managed by library: $real"
      ;;
  esac
  if [[ ! -e "$real" ]]; then
    die "Broken symlink: $src -> $real"
  fi
  mv "$real" "$dest"
  rm "$src"
else
  mv "$src" "$dest"
fi

echo "Moved to $dest"
