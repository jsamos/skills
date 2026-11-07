#!/usr/bin/env bash
set -euo pipefail

_COMMON_DIR=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SKILL_DIR=$(cd -P "$_COMMON_DIR/.." && pwd)
CONFIG_FILE="${SKILL_DIR}/library-root"

die() {
  echo "$*" >&2
  exit 1
}

realpath_of() {
  python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' "$1"
}

read_library() {
  if [[ ! -f "$CONFIG_FILE" ]]; then
    die "Library path not configured. Run skill-setup first."
  fi
  local root
  root=$(tr -d '[:space:]' <"$CONFIG_FILE")
  if [[ -z "$root" || ! -d "$root/me" ]]; then
    die "Invalid library path in ${CONFIG_FILE}. Run skill-setup again."
  fi
  printf '%s\n' "$root"
}

validate_name() {
  local name="$1"
  [[ -n "$name" ]] || die "Skill name required"
  if [[ "$name" == */* || "$name" == "." || "$name" == ".." ]]; then
    die "Invalid skill name: $name"
  fi
}

resolve_skill() {
  local library="$1" name="$2"
  if [[ -d "$library/me/$name" ]]; then
    printf '%s\n' "$library/me/$name"
  elif [[ -d "$library/vendor/$name" ]]; then
    printf '%s\n' "$library/vendor/$name"
  else
    die "Skill not found in me/ or vendor/: $name"
  fi
}
