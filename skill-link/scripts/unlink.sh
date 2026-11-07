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

project_dir="${2:-.}"
project_dir=$(cd "$project_dir" && pwd)

link_path="${project_dir}/.agents/skills/${name}"

if [[ ! -e "$link_path" && ! -L "$link_path" ]]; then
  echo "Not linked: $link_path"
  exit 0
fi

if [[ ! -L "$link_path" ]]; then
  die "Refusing to remove non-symlink: $link_path"
fi

rm "$link_path"
echo "Unlinked $link_path"
