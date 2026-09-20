---
name: extract-audio
description: Extract audio from video files with the extract-audio Docker CLI bundled in this skill. Use when the user wants to separate, extract, or pull audio from a video, convert a soundtrack to mp3/wav/flac/aac/ogg, or split a video into audio plus a silent video.
---

# Extract audio from video

This skill is self-contained. Run `scripts/extract-audio` from this skill directory. Do not call ffmpeg or `docker run` directly, and do not install the CLI onto PATH.

The script starts Docker Desktop if needed, waits until the daemon is ready, and builds `extract-audio:latest` from this skill if the image is missing.

## Command

`$SKILL_DIR` is the directory that contains this `SKILL.md`.

```bash
"$SKILL_DIR/scripts/extract-audio" [options] <video> [output]
```

On this machine that is:

```bash
~/.agents/skills/extract-audio/scripts/extract-audio [options] <video> [output]
```

- Default output: `<video-basename>.mp3` next to the input
- `-f, --format FORMAT`: `mp3` (default), `wav`, `flac`, `aac`, `m4a`, `ogg`, `copy`
- `-o, --output PATH` or a second positional: output audio path
- `--split`: also write `<name>.silent.<ext>` (video with audio removed)

Works from any working directory. Pass a relative or absolute path to the video.

## Examples

```bash
~/.agents/skills/extract-audio/scripts/extract-audio lecture.mov
~/.agents/skills/extract-audio/scripts/extract-audio ~/Downloads/clip.mp4 soundtrack.wav
~/.agents/skills/extract-audio/scripts/extract-audio clip.mp4 -f flac
~/.agents/skills/extract-audio/scripts/extract-audio clip.mp4 --split
```
