#!/bin/sh
set -eu

FORMAT="mp3"
SPLIT=0
INPUT=""
OUTPUT=""

usage() {
  cat <<'EOF'
Usage: extract-audio [options] <video> [output]

Extract audio from a video file.

Options:
  -f, --format FORMAT   mp3 (default), wav, flac, aac, m4a, ogg, copy
  -o, --output PATH     Output audio file
  --split               Also write a video copy with audio removed
  -h, --help            Show this help

Examples:
  extract-audio lecture.mov
  extract-audio ~/Downloads/clip.mp4 soundtrack.wav
  extract-audio clip.mp4 -f flac
  extract-audio clip.mp4 --split
EOF
}

die() {
  echo "extract-audio: $1" >&2
  exit 1
}

host_path() {
  case "$1" in
    /in/*)
      printf '%s/%s\n' "${HOST_INPUT_DIR:-/in}" "${1#/in/}"
      ;;
    /out/*)
      printf '%s/%s\n' "${HOST_OUTPUT_DIR:-/out}" "${1#/out/}"
      ;;
    *)
      printf '%s\n' "$1"
      ;;
  esac
}

while [ $# -gt 0 ]; do
  case "$1" in
    -f|--format)
      [ $# -ge 2 ] || die "missing value for $1"
      FORMAT="$2"
      shift 2
      ;;
    -o|--output)
      [ $# -ge 2 ] || die "missing value for $1"
      OUTPUT="$2"
      shift 2
      ;;
    --split)
      SPLIT=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      die "unknown option: $1"
      ;;
    *)
      if [ -z "$INPUT" ]; then
        INPUT="$1"
      elif [ -z "$OUTPUT" ]; then
        OUTPUT="$1"
      else
        die "unexpected argument: $1"
      fi
      shift
      ;;
  esac
done

[ -n "$INPUT" ] || { usage >&2; exit 1; }
[ -f "$INPUT" ] || die "file not found: $INPUT"

CODEC="$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=nw=1:nk=1 "$INPUT" || true)"
[ -n "$CODEC" ] || die "no audio stream found in $INPUT"

ext_for_copy() {
  case "$1" in
    aac) echo m4a ;;
    mp3) echo mp3 ;;
    opus) echo opus ;;
    vorbis) echo ogg ;;
    flac) echo flac ;;
    pcm_*|pcm) echo wav ;;
    ac3|eac3) echo ac3 ;;
    *) echo mka ;;
  esac
}

ext_for_format() {
  case "$1" in
    mp3) echo mp3 ;;
    wav) echo wav ;;
    flac) echo flac ;;
    aac|m4a) echo m4a ;;
    ogg) echo ogg ;;
    copy) ext_for_copy "$CODEC" ;;
    *) die "unsupported format: $1 (use mp3, wav, flac, aac, m4a, ogg, or copy)" ;;
  esac
}

FORMAT="$(printf '%s' "$FORMAT" | tr '[:upper:]' '[:lower:]')"
EXT="$(ext_for_format "$FORMAT")"
BASE="${INPUT%.*}"
[ -n "$OUTPUT" ] || OUTPUT="${BASE}.${EXT}"

PARENT="$(dirname "$OUTPUT")"
mkdir -p "$PARENT"

run_ffmpeg() {
  ffmpeg -hide_banner -loglevel error -stats -y "$@"
}

case "$FORMAT" in
  mp3)
    run_ffmpeg -i "$INPUT" -vn -acodec libmp3lame -q:a 2 "$OUTPUT"
    ;;
  wav)
    run_ffmpeg -i "$INPUT" -vn -acodec pcm_s16le "$OUTPUT"
    ;;
  flac)
    run_ffmpeg -i "$INPUT" -vn -acodec flac "$OUTPUT"
    ;;
  aac|m4a)
    run_ffmpeg -i "$INPUT" -vn -c:a aac -b:a 192k "$OUTPUT"
    ;;
  ogg)
    run_ffmpeg -i "$INPUT" -vn -c:a libvorbis -q:a 5 "$OUTPUT"
    ;;
  copy)
    run_ffmpeg -i "$INPUT" -vn -c:a copy "$OUTPUT"
    ;;
esac

echo "Wrote $(host_path "$OUTPUT")"

if [ "$SPLIT" -eq 1 ]; then
  VIDEO_EXT="${INPUT##*.}"
  VIDEO_OUT="${BASE}.silent.${VIDEO_EXT}"
  run_ffmpeg -i "$INPUT" -c:v copy -an "$VIDEO_OUT"
  echo "Wrote $(host_path "$VIDEO_OUT")"
fi
