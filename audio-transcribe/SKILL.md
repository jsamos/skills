---
name: audio-transcribe
description: Transcribe audio or video files to text with the audio-transcribe Docker CLI (Vosk). Use when the user wants a transcript, captions, subtitles, or speech-to-text from an audio or video file.
---

# Transcribe audio

This skill is self-contained. Run `scripts/audio-transcribe` from this skill directory. Do not call vosk, ffmpeg, or `docker run` directly.

The script checks that Docker is running and builds `audio-transcribe:latest` from this skill if the image is missing. If Docker is not installed or not running, it exits with an error.

## Command

`$SKILL_DIR` is the directory that contains this `SKILL.md`.

```bash
"$SKILL_DIR/scripts/audio-transcribe" [options] <audio> [output]
```

- Default output: `<audio-basename>.txt` next to the input
- `-f, --format FORMAT`: `txt` (default), `srt`, `json`
- `-o, --output PATH` or a second positional: output transcript path
- `-m, --model PATH`: optional Vosk model directory (default is the image's US English small model)

Works from any working directory. Pass a relative or absolute path to the audio or video file.

## Examples

```bash
"$SKILL_DIR/scripts/audio-transcribe" lecture.mp3
"$SKILL_DIR/scripts/audio-transcribe" interview.m4a transcript.txt
"$SKILL_DIR/scripts/audio-transcribe" clip.wav -f srt
```
