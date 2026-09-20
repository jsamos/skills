# extract-audio

Pull the audio track out of a video file using ffmpeg in Docker.

This directory is the source of truth (`~/.agents/skills/extract-audio`). `~/code/containers/extract-audio` is a symlink to it.

## Requirements

- Docker Desktop (the script starts it if it is not running)
- macOS

You do not need ffmpeg on your Mac, and you do not need this command on your PATH.

## Usage

Run the script from any directory. Pass a relative or absolute path to the video.

```bash
~/.agents/skills/extract-audio/scripts/extract-audio lecture.mov
```

That writes `lecture.mp3` next to the video.

```bash
~/.agents/skills/extract-audio/scripts/extract-audio ~/Downloads/clip.mp4 soundtrack.wav
~/.agents/skills/extract-audio/scripts/extract-audio clip.mp4 -f flac
~/.agents/skills/extract-audio/scripts/extract-audio clip.mp4 --split
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

## Rebuild the image

Usually unnecessary. To rebuild explicitly:

```bash
~/.agents/skills/extract-audio/scripts/install.sh
```

## Layout

```
extract-audio/
  Dockerfile              # Alpine + ffmpeg
  SKILL.md                # Instructions for agents
  scripts/extract-audio   # Command you run
  scripts/extract.sh      # Runs inside the container
  scripts/install.sh      # Optional image rebuild
```
