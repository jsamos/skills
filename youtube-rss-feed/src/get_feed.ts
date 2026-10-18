#!/usr/bin/env node
/**
 * Fetch a YouTube channel's RSS (Atom) feed.
 *
 * Usage:
 *   node dist/get_feed.js CHANNEL_ID
 *   node dist/get_feed.js CHANNEL_ID --json
 */

import Parser from "rss-parser";

const FEED_URL = "https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}";

interface YouTubeFeedItem extends Parser.Item {
  mediaGroup?: { "media:description"?: unknown[] };
}

function isChannelId(arg: string): boolean {
  return /^UC[\w-]{22}$/.test(arg);
}

function parseArgs(): { channelId: string; jsonMode: boolean } {
  const argv = process.argv.slice(2);
  const jsonMode = argv.includes("--json");
  const input = argv.find((a) => a !== "--json")?.trim() ?? "";

  if (!input || !isChannelId(input)) {
    process.stderr.write("Usage: node get_feed.js CHANNEL_ID [--json]\n");
    process.stderr.write("CHANNEL_ID must be a 24-character string starting with UC.\n");
    process.exit(1);
  }

  return { channelId: input, jsonMode };
}

function formatPublished(dateStr: string): string {
  const date = new Date(dateStr);
  const m = String(date.getUTCMonth() + 1).padStart(2, "0");
  const d = String(date.getUTCDate()).padStart(2, "0");
  return `${m} / ${d}`;
}

function getMediaDescription(item: YouTubeFeedItem): string {
  const group = item.mediaGroup;
  if (!group || !Array.isArray(group["media:description"])) return "";
  const raw = group["media:description"][0];
  if (typeof raw === "string") return raw;
  if (raw && typeof (raw as { _?: string })._ === "string") return (raw as { _: string })._;
  return "";
}

async function main(): Promise<void> {
  const { channelId, jsonMode } = parseArgs();
  const url = FEED_URL.replace("{channel_id}", channelId);

  const parser = new Parser<Parser.Output<YouTubeFeedItem>, YouTubeFeedItem>({
    customFields: {
      item: [["media:group", "mediaGroup"]],
    },
  });

  let feed: Parser.Output<YouTubeFeedItem>;
  try {
    feed = await parser.parseURL(url);
  } catch (err) {
    const msg = err instanceof Error ? err.message : String(err);
    process.stderr.write(`Failed to fetch feed: ${msg}\n`);
    process.exit(1);
  }

  if (!feed.items?.length) {
    if (jsonMode) process.stdout.write(JSON.stringify({ title: feed.title, link: feed.link, feedUrl: feed.feedUrl, items: [] }, null, 2));
    process.exit(0);
  }

  if (jsonMode) {
    const full = {
      title: feed.title,
      link: feed.link,
      feedUrl: feed.feedUrl,
      items: feed.items.map((item) => ({
        title: item.title ?? "",
        link: item.link ?? "",
        pubDate: item.pubDate ?? item.isoDate ?? "",
        description: getMediaDescription(item),
      })),
    };
    process.stdout.write(JSON.stringify(full, null, 2));
    return;
  }

  for (const item of feed.items) {
    const title = item.title ?? "";
    const dateStr = item.pubDate ?? item.isoDate ?? "";
    const published = dateStr ? formatPublished(dateStr) : "";
    process.stdout.write(`${title}\t${published}\n`);
  }
}

main();
