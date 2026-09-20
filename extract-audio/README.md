# extract-audio

Pull the audio track out of a video file using ffmpeg in Docker. You do not need ffmpeg installed on the host.

## Requirements

- [Docker](https://docs.docker.com/get-docker/), running

## Usage

From this directory, run `scripts/extract-audio` with a relative or absolute path to a video. It can be invoked from any working directory.

```bash
./scripts/extract-audio lecture.mov
```

That writes `lecture.mp3` next to the video.

```bash
./scripts/extract-audio ~/Downloads/clip.mp4 soundtrack.wav
./scripts/extract-audio clip.mp4 -f flac
./scripts/extract-audio clip.mp4 --split
```

`--split` also writes a copy of the video with the audio removed, e.g. `clip.silent.mp4`.

If the Docker image is missing, the script builds it first.

## Options

| Option | Description |
| --- | --- |
| `-f`, `--format FORMAT` | `mp3` (default), `wav`, `flac`, `aac`, `m4a`, `ogg`, or `copy` |
| `-o`, `--output PATH` | Output audio file (or pass it as the second argument) |
| `--split` | Also write `<name>.silent.<ext>` |
| `-h`, `--help` | Show help |

`copy` keeps the original audio codec and picks a matching extension (for example `.m4a` for AAC).

## Use as an agent skill

This directory is an agent skill: `SKILL.md` tells an agent how to run the bundled script.

Install it by copying or cloning this folder into your skills directory, keeping the folder name `extract-audio`:

```bash
git clone <this-repo-url> ~/.agents/skills/extract-audio
```

Other common locations:

- `~/.agents/skills/extract-audio`
- `~/.cursor/skills/extract-audio` (Cursor, all projects)
- `.cursor/skills/extract-audio` (Cursor, this project only)

Then ask in natural language, for example:

- Extract the audio from `lecture.mov`
- Make a wav of `~/Downloads/clip.mp4`
- Split `clip.mp4` into audio and a silent video

## Rebuild the image

To rebuild the image:

```bash
./scripts/install.sh
```

## Layout

```
.
├── Dockerfile              # Alpine + ffmpeg
├── SKILL.md                # Instructions for agents
├── scripts/extract-audio   # Command you or an agent run
├── scripts/extract.sh      # Runs inside the container
└── scripts/install.sh      # Optional image rebuild
```
