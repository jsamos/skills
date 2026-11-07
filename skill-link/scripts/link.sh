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

library=$(read_library)
resolved=$(resolve_skill "$library" "$name")

target_dir="${project_dir}/.agents/skills"
link_path="${target_dir}/${name}"

mkdir -p "$target_dir"

if [[ -e "$link_path" && ! -L "$link_path" ]]; then
  die "Refusing to overwrite non-symlink: $link_path"
fi

ln -sfn "$resolved" "$link_path"
echo "Linked $link_path -> $resolved"
