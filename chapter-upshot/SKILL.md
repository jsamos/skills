---
name: chapter-upshot
description: Produce self-contained upshots, keywords, or short summaries of a chapter or segment from transcripts or long-form source. Use when the user asks for an upshot, main point, takeaway, keywords, or a short explanation of a chapter, topic, or segment from a transcript, podcast, or recording.
---

# Chapter Upshot

Distill one chapter or segment into what the reader needs to move on — **without assuming they read or heard the source**.

## Input

- **Source text:** transcript file or pasted text (read the full segment before writing).
- **Scope:** one chapter title from a chapter outline, a topic name, or a time range the user names.
- If a `{source-slug}-chapters.txt` file exists, use it to locate the segment. Otherwise follow topic pivots in the transcript.

## Output modes

Match the user's request **exactly**. Do not add other modes.

| User asks for | Deliver |
|---|---|
| **keywords only** | Keywords only. One line. No prose, bullets, or explanation. |
| **main point** / **be short** | One or two sentences. Self-contained. |
| **upshot** | One short paragraph (2–4 sentences). Self-contained. |
| Full explanation (no mode named) | Short prose; still self-contained. Lead with the upshot paragraph unless they asked for keywords first. |

When the user corrects format ("keywords only", "that's ambiguous"), switch mode and **drop** anything outside that mode.

## Upshot recipe

Every upshot must answer, in plain language:

1. **What's the problem or situation?** (define jargon on first use)
2. **Who is doing what?** Name the company, person, or product and **what they sell, build, or claim** — concretely, not "they're betting on X."
3. **What happened or what's the verdict?** Reaction, backlash, skepticism, or host/source conclusion.

### Self-contained rules

- **No vague referents.** Not "labs will pay anyway" — say **what they pay for** (e.g. design data labeling).
- **No "wrong framing" without saying the framing.** Name the pitch, product, or claim.
- **Define terms once.** If you use slop, AR, IPO, etc., anchor it in the same sentence.
- **Don't assume chapter context.** The upshot must stand alone in a chat with no prior messages.

## Workflow

1. Read the segment for that chapter or topic.
2. Pick the output mode from the user's message.
3. Draft using the upshot recipe (even for short modes — compress, don't omit the concrete "what").
4. **Quality check** (required before sending):
   - Could someone who never saw the source understand every noun and verb?
   - Is the business/mechanism named, not hand-waved?
   - Did I deliver **only** what the mode allows?
5. Save only if the user asks. Default path: `{source-slug}-upshot-{chapter-slug}.txt`.

## Anti-patterns

- Keywords plus explanation when they said **keywords only**.
- Contradictory "but/so" logic without resolving it (e.g. "can't codify X, so demand for codifying X").
- Bullet dumps when they asked for upshot or main point.
- Host commentary without saying **who** hosts are if it matters to the verdict.

For good and bad examples from real corrections, see [examples.md](examples.md).
