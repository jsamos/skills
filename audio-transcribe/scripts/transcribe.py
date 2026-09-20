#!/usr/bin/env python3
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def die(message: str) -> None:
    print(f"audio-transcribe: {message}", file=sys.stderr)
    raise SystemExit(1)


def host_path(path: str) -> str:
    if path.startswith("/in/"):
        return f"{os.environ.get('HOST_INPUT_DIR', '/in')}/{path[4:]}"
    if path.startswith("/out/"):
        return f"{os.environ.get('HOST_OUTPUT_DIR', '/out')}/{path[5:]}"
    return path


def srt_timestamp(seconds: float) -> str:
    hours = int(seconds // 3600)
    minutes = int((seconds % 3600) // 60)
    secs = seconds % 60
    return f"{hours:02d}:{minutes:02d}:{secs:06.3f}".replace(".", ",")


def to_srt(words: list[dict[str, object]], words_per_line: int = 7) -> str:
    if not words:
        return ""
    chunks = [words[i : i + words_per_line] for i in range(0, len(words), words_per_line)]
    blocks: list[str] = []
    for index, chunk in enumerate(chunks, start=1):
        start = float(chunk[0]["start"])
        end = float(chunk[-1]["end"])
        text = " ".join(str(word["word"]) for word in chunk)
        blocks.append(f"{index}\n{srt_timestamp(start)} --> {srt_timestamp(end)}\n{text}\n")
    return "\n".join(blocks)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="audio-transcribe",
        description="Transcribe an audio file with Vosk.",
    )
    parser.add_argument("input", help="Audio or video file")
    parser.add_argument("output", nargs="?", help="Output transcript path")
    parser.add_argument(
        "-f",
        "--format",
        dest="fmt",
        choices=("txt", "srt", "json"),
        default="txt",
        help="Output format (default: txt)",
    )
    parser.add_argument("-o", "--output", dest="output_opt", help="Output transcript path")
    parser.add_argument(
        "-m",
        "--model",
        default=os.environ.get("VOSK_MODEL", "/models/en-us"),
        help="Path to a Vosk model directory",
    )
    return parser.parse_args(argv)


def transcribe(input_path: Path, model_path: Path) -> tuple[list[str], list[dict[str, object]], list[dict[str, object]]]:
    from vosk import KaldiRecognizer, Model, SetLogLevel

    SetLogLevel(-1)
    if not model_path.is_dir():
        die(f"model not found: {model_path}")

    model = Model(str(model_path))
    rec = KaldiRecognizer(model, 16000)
    rec.SetWords(True)

    proc = subprocess.Popen(
        [
            "ffmpeg",
            "-hide_banner",
            "-loglevel",
            "error",
            "-i",
            str(input_path),
            "-ar",
            "16000",
            "-ac",
            "1",
            "-f",
            "s16le",
            "-",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if proc.stdout is None:
        die("failed to start ffmpeg")

    texts: list[str] = []
    words: list[dict[str, object]] = []
    results: list[dict[str, object]] = []

    while True:
        data = proc.stdout.read(4000)
        if not data:
            break
        if rec.AcceptWaveform(data):
            parsed = json.loads(rec.Result())
            results.append(parsed)
            text = parsed.get("text")
            if text:
                texts.append(text)
            words.extend(parsed.get("result") or [])

    parsed = json.loads(rec.FinalResult())
    results.append(parsed)
    text = parsed.get("text")
    if text:
        texts.append(text)
    words.extend(parsed.get("result") or [])

    _, stderr = proc.communicate()
    if proc.returncode != 0:
        err = stderr.decode("utf-8", errors="replace").strip()
        die(err or "ffmpeg failed")

    return texts, words, results


def main(argv: list[str]) -> None:
    args = parse_args(argv)
    input_path = Path(args.input)
    if not input_path.is_file():
        die(f"file not found: {input_path}")

    output = args.output_opt or args.output
    if not output:
        output = str(input_path.with_suffix(f".{args.fmt}"))

    output_path = Path(output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    texts, words, results = transcribe(input_path, Path(args.model))

    if args.fmt == "txt":
        output_path.write_text((" ".join(texts).strip() + "\n") if texts else "", encoding="utf-8")
    elif args.fmt == "srt":
        output_path.write_text(to_srt(words), encoding="utf-8")
    else:
        output_path.write_text(json.dumps(results, indent=2) + "\n", encoding="utf-8")

    print(f"Wrote {host_path(str(output_path))}")


if __name__ == "__main__":
    main(sys.argv[1:])
