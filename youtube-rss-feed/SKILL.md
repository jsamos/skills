---
name: youtube-feed
description: Fetch a YouTube channel's RSS feed and list video titles with published date (MM / DD), or resolve a channel handle to its channel ID. Use when the user asks for a channel's feed, recent videos, or channel ID. Supports both channel IDs (UC...) and @handles.
---

# YouTube Feed

Fetch the RSS (Atom) feed for a YouTube channel, or resolve a `@handle` to its channel ID. No API key required.

**Requirements:** Node.js 18+ and npm.

## Before running

Let `SKILL_DIR` be the directory containing this `SKILL.md`.

Install and build if not already done:

```bash
cd SKILL_DIR && [ -d node_modules ] || npm install && [ -f dist/get_feed.js ] || npm run build
```

## Scripts

### get_feed.js — fetch a channel's recent videos

Accepts a channel ID (24-character string starting with `UC`).

```bash
cd SKILL_DIR && node dist/get_feed.js CHANNEL_ID
cd SKILL_DIR && node dist/get_feed.js CHANNEL_ID --json
```

### get_channel_id.js — resolve a @handle to a channel ID

Accepts one or more `@handles`. Fetches the YouTube channel page and extracts the ID.

```bash
cd SKILL_DIR && node dist/get_channel_id.js @handle
cd SKILL_DIR && node dist/get_channel_id.js @handle1 @handle2 --json
```

## Workflow

When the user provides a **channel ID** (starts with `UC`, 24 characters): run `get_feed.js` directly.

When the user provides a **@handle**: first run `get_channel_id.js` to resolve it to a channel ID, then pass that ID to `get_feed.js`.

**Always use the exact handle the user provided.** Do not rename, correct, or guess a different handle. If the script exits with an HTTP 404, stop and tell the user the handle was not found. Suggest they may have a typo and ask them to double-check the handle.

## Output

**get_feed.js (default):** One line per video: `Title\tMM / DD` (tab-separated).

**get_feed.js (--json):** `{ "title", "link", "feedUrl", "items": [ { "title", "link", "pubDate", "description" } ] }`. Each item's `description` includes chapter timestamps and summaries when available.

**get_channel_id.js (single handle):** Prints the channel ID on one line.

**get_channel_id.js (multiple handles, --json):** `{ "@handle": "CHANNEL_ID", ... }`.
