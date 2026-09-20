#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMAGE="${EXTRACT_AUDIO_IMAGE:-extract-audio:latest}"

die() {
  echo "extract-audio: $1" >&2
  exit 1
}

if ! command -v docker >/dev/null 2>&1; then
  die "docker is not installed"
fi

if ! docker info >/dev/null 2>&1; then
  echo "extract-audio: Docker is not running; starting Docker Desktop..." >&2
  open -a Docker || die "could not start Docker Desktop"
  i=0
  while [ "$i" -lt 60 ]; do
    sleep 2
    if docker info >/dev/null 2>&1; then
      break
    fi
    i=$((i + 1))
  done
  if ! docker info >/dev/null 2>&1; then
    die "docker did not become ready after starting Docker Desktop"
  fi
fi

docker build -t "$IMAGE" "$ROOT"
echo "Built $IMAGE"
