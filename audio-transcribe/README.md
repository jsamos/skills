# audio-transcribe

Transcribe speech from an audio or video file using [Vosk](https://alphacephei.com/vosk/) in Docker. You do not need Vosk or ffmpeg installed on the host.

The image uses Vosk API **0.3.50** (current GitHub release; Alpine `py3-vosk-api` / `vosk-api` 0.3.50-r1) and ships `vosk-model-small-en-us-0.15`.

## Requirements

- [Docker](https://docs.docker.com/get-docker/), running

## Usage

From this directory, run `scripts/audio-transcribe` with a relative or absolute path to an audio or video file. It can be invoked from any working directory.

```bash
./scripts/audio-transcribe lecture.mp3
```

That writes `lecture.txt` next to the file.

```bash
./scripts/audio-transcribe interview.m4a transcript.txt
./scripts/audio-transcribe clip.wav -f srt
./scripts/audio-transcribe clip.wav -f json
```

If the Docker image is missing, the script builds it first. The first build downloads the English model.

## Options

| Option | Description |
| --- | --- |
| `-f`, `--format FORMAT` | `txt` (default), `srt`, or `json` |
| `-o`, `--output PATH` | Output transcript file (or pass it as the second argument) |
| `-m`, `--model PATH` | Directory containing a [Vosk model](https://alphacephei.com/vosk/models) |
| `-h`, `--help` | Show help |

## Use as an agent skill

This directory is an agent skill: `SKILL.md` tells an agent how to run the bundled script.

Install it by copying or cloning this folder into your skills directory, keeping the folder name `audio-transcribe`:

```bash
git clone <this-repo-url> ~/.agents/skills/audio-transcribe
```

Other common locations:

- `~/.agents/skills/audio-transcribe`
- `~/.cursor/skills/audio-transcribe` (Cursor, all projects)
- `.cursor/skills/audio-transcribe` (Cursor, this project only)

Then ask in natural language, for example:

- Transcribe `lecture.mp3`
- Make an SRT of `interview.m4a`
- Write a transcript of `clip.wav` to `notes.txt`

## Rebuild the image

To rebuild the image:

```bash
./scripts/install.sh
```

## Layout

```
.
├── Dockerfile                # Alpine + Vosk 0.3.50 + English model
├── SKILL.md                  # Instructions for agents
├── scripts/audio-transcribe  # Command you or an agent run
├── scripts/transcribe.py     # Runs inside the container
└── scripts/install.sh        # Optional image rebuild
```
