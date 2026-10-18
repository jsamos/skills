#!/usr/bin/env node
/**
 * Resolve YouTube channel handle(s) to channel ID(s).
 * Fetches each channel page and extracts channel_id from the HTML source.
 * Caches results in .channel_cache.json next to this script.
 *
 * Usage:
 *   node dist/get_channel_id.js @handle
 *   node dist/get_channel_id.js @handle1 @handle2 --json
 *   node dist/get_channel_id.js @handle1 @handle2 --delay SECONDS
 */

import { readFileSync, writeFileSync, existsSync } from "fs";
import { dirname, join } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const CACHE_FILE = join(__dirname, ".channel_cache.json");
const CHANNEL_PAGE_URL = "https://www.youtube.com/@{handle}";
const DELAY_BETWEEN_FETCHES_MS = 2000;

function loadCache(): Record<string, string> {
  if (!existsSync(CACHE_FILE)) return {};
  try {
    const raw = readFileSync(CACHE_FILE, "utf-8");
    const data = JSON.parse(raw) as Record<string, string>;
    if (data && typeof data === "object" && !Array.isArray(data)) return data;
  } catch {
    // ignore corrupt cache
  }
  return {};
}

function saveCache(cache: Record<string, string>): void {
  writeFileSync(CACHE_FILE, JSON.stringify(cache, null, 2) + "\n");
}

function normalizeHandle(input: string): string {
  const trimmed = input.trim();
  if (!trimmed) throw new Error("Empty channel handle");
  const urlMatch = trimmed.match(
    /youtube\.com\/(@[a-zA-Z0-9_-]+|c\/[a-zA-Z0-9_-]+)/i
  );
  if (urlMatch) {
    const part = urlMatch[1];
    return part.startsWith("@") ? part : `@${part.replace("c/", "")}`;
  }
  return trimmed.startsWith("@") ? trimmed : `@${trimmed}`;
}

function extractChannelIdFromHtml(html: string): string | null {
  const channelIdMatch = html.match(/channel_id=([A-Za-z0-9_-]{24})/);
  if (channelIdMatch) return channelIdMatch[1];
  const canonicalMatch = html.match(
    /youtube\.com\/channel\/(UC[A-Za-z0-9_-]{22})/
  );
  if (canonicalMatch) return canonicalMatch[1];
  return null;
}

async function fetchChannelId(handle: string): Promise<string> {
  const url = CHANNEL_PAGE_URL.replace("{handle}", handle.slice(1));
  const res = await fetch(url, {
    headers: { "Accept-Language": "en-US" },
  });
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} for ${handle} (${url})`);
  }
  const html = await res.text();
  const channelId = extractChannelIdFromHtml(html);
  if (!channelId) {
    throw new Error(`Could not find channel_id in page for ${handle}`);
  }
  return channelId;
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main(): Promise<void> {
  const args = process.argv.slice(2);
  const jsonFlag = args.includes("--json");
  const delayIdx = args.indexOf("--delay");
  const delaySec =
    delayIdx >= 0 && args[delayIdx + 1]
      ? Number(args[delayIdx + 1])
      : DELAY_BETWEEN_FETCHES_MS / 1000;
  const rawHandles = args.filter(
    (a) => a !== "--json" && a !== "--delay" && !(delayIdx >= 0 && a === args[delayIdx + 1])
  );

  if (rawHandles.length === 0) {
    process.stderr.write(
      "Usage: node get_channel_id.js @handle1 [@handle2 ...] [--json] [--delay SECONDS]\n"
    );
    process.exit(1);
  }

  const handles: string[] = [];
  for (const raw of rawHandles) {
    try {
      handles.push(normalizeHandle(raw));
    } catch {
      process.stderr.write(`Invalid handle: ${raw}\n`);
      process.exit(1);
    }
  }

  const cache = loadCache();
  let cacheUpdated = false;
  const results: Record<string, string> = {};
  let fetchCount = 0;

  for (const handle of handles) {
    const cached = cache[handle];
    if (cached) {
      results[handle] = cached;
      continue;
    }

    if (fetchCount > 0) await sleep(delaySec * 1000);
    try {
      const channelId = await fetchChannelId(handle);
      results[handle] = channelId;
      cache[handle] = channelId;
      cacheUpdated = true;
      fetchCount++;
    } catch (err) {
      const msg = err instanceof Error ? err.message : String(err);
      process.stderr.write(`${handle}: ${msg}\n`);
      process.exit(1);
    }
  }

  if (cacheUpdated) {
    saveCache(cache);
  }

  if (jsonFlag) {
    process.stdout.write(JSON.stringify(results, null, 0) + "\n");
    return;
  }

  if (Object.keys(results).length === 1) {
    const [id] = Object.values(results);
    process.stdout.write(id + "\n");
    return;
  }

  for (const [handle, channelId] of Object.entries(results)) {
    process.stdout.write(`${handle}\t${channelId}\n`);
  }
}

main();
