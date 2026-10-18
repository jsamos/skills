# youtube-feed

An AI agent skill that fetches a YouTube channel's recent videos from its public RSS feed. Returns titles, dates, links, and full descriptions including chapter timestamps. Supports both channel IDs and `@handles`. No API key required.

## Install

Requires Node.js 18+ and npm.

Clone this repo somewhere on your machine, e.g.:

```bash
git clone <repo-url> ~/.agents/skills/youtube-feed
```

The agent handles installing dependencies and building automatically on first use.

## Usage

Once registered, ask your agent:

- **"youtube feed @channelhandle"** — resolves the handle and lists recent videos
- **"youtube feed UCxxxxxxxxxxxxxxxxxxxxxx"** — lists recent videos by channel ID
- **"youtube feed @channelhandle --json"** — get full structured data including descriptions and chapter timestamps

The agent resolves `@handles` to channel IDs automatically by fetching the YouTube channel page. Resolved handles are cached locally, so repeat lookups are instant.

You can also just ask for a channel ID without fetching the feed:

- **"what's the channel ID for @channelhandle"**

## What you get back

**Default** — titles and publish dates for the most recent ~15 videos.

**With `--json`** — a structured object with title, link, publish date, and the full video description (including chapter timestamps and summaries when available) for each video.

## Limitations

- YouTube's public feed only returns the most recent ~15 videos.
- Some channels may not populate the description field in their feed.
