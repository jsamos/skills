#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMAGE="${AUDIO_TRANSCRIBE_IMAGE:-audio-transcribe:latest}"

die() {
  echo "audio-transcribe: $1" >&2
  exit 1
}

if ! command -v docker >/dev/null 2>&1; then
  die "docker is not installed"
fi

if ! docker info >/dev/null 2>&1; then
  die "docker is not running"
fi

docker build -t "$IMAGE" "$ROOT"
echo "Built $IMAGE"
