---
name: chapter-outline
description: Generate book-style chapter outlines from transcripts or other long-form source material. Use when the user asks for chapters, a chapter list, or a table of contents derived from a transcript, recording, podcast, interview, lecture, or similar content.
---

# Chapter Outline

Produce a **book-style chapter outline** from source material. Chapters name the **subjects, stories, and arguments** in the material — the way a nonfiction editor would divide it — not the shape of the recording or document.

## Input

Work from the **full source text**. This may be a transcript file, pasted text, or material obtained by another skill or tool. Read it completely before naming chapters.

## Scope

The outline is **selective, not exhaustive**. Map substantive story arcs only — material that doesn't support a chapter is omitted, not forced into a neighbor.

- **Omit ephemeral beats** — brief reactions to memes, posts, or asides get no entry.
- **If it doesn't fit the title, it's out** — every beat in a chapter must match the title's subject.
- **One subject per chapter** — title the story, not a bucket of nearby material.
- **Same subject, one chapter** — all beats on the same company, product, person, or event stay together, even when the recording returns to them later; a new angle or cited piece is not a new chapter.

## A–B–A patterns

Recordings often move **Subject A → Subject B → Subject A** — the host or speaker leaves the main thread, covers something else, then returns. Do not treat that return as a new chapter break. Group by theme, not by when topics appear.

When Subject B sits between two beats on Subject A, handle Subject B in one of three ways:

1. **Fold into Subject A** — Subject B is short, illustrative, or only exists to clarify A. Keep it inside A's chapter; do not give B its own heading.
2. **Its own chapter, in context of A** — Subject B has enough substance to stand alone but only makes sense as part of A's story (a competitor, constraint, or comparison). Give B a chapter, but title and place it so a reader sees the link to A — e.g. *Meta's Token Factory Gamble — SpaceX's Cloud Rival* rather than a free-floating *Meta's AI Strategy*.
3. **Omit as a tangent** — Subject B is ephemeral, off-thread, or too thin to earn a chapter or a place inside A. Drop it from the outline.

Pick one before delivering. If B would split A across two chapters, prefer (1) or (3) over mirroring the recording order.

## Workflow

1. **Read for story arcs.** Follow where the material moves: which person, company, event, claim, or question is being explored?
2. **Mark natural breaks.** A new chapter begins when the central subject clearly changes and enough material follows to stand on its own.
3. **Name each chapter.** Write a title a reader would recognize on a book spine — specific to *what* is discussed.
4. **Review the set.** Each chapter should cover one coherent subject. Chapters should feel like distinct sections of the same book, grouped by theme — not mirroring the order topics appear in the recording. Resolve any A–B–A patterns (see above). If two or more chapters share the same central subject, merge before delivering. Do not save or post output until this pass is done.
5. **Deliver** using the output format below.

## Chapter titles

A good title answers: **"What is this section about?"**

- Lead with the **subject** — a person, company, event, technology, argument, or story.
- Use the **headline test**: would someone who read or heard the material nod and say "yes, that's what that part was about"?
- Keep titles **concise** (roughly 3–10 words). Subtitles after an em dash are fine when they add clarity.
- Keep material only when it **sets up the chapter it sits in**; otherwise omit it.

## Granularity

Calibrate to the **material**:

- A focused short piece may need 3–4 chapters.
- A wide-ranging long piece may need 6–10.
- When the user asks for fewer chapters, **merge stories that belong together**.
- When the user asks for more, **split only where the subject genuinely shifts**.

## Output format

```text
[Source title]
[Source reference — URL, file path, or citation, if available]

Chapter Title One
Chapter Title Two
Chapter Title Three
```

Save to the path the user specifies. If none is given, use a sensible name derived from the source (e.g. `{source-slug}-chapters.txt`).

## Files

- **While working:** save the outline to `{source-slug}-chapters.txt` (or a user-specified path).
- **When the user says "clean up":** delete the files you created for this task (e.g. `{source-slug}-chapters.txt`, `{source-slug}-transcript.txt`).

## Quality check

Before delivering, confirm each title:

1. Names a **subject**, not a format ("intro", "news roundup", "everything else").
2. Would make sense **without reading or hearing the source**.
3. Covers **enough substance** to justify its own chapter.
4. Gaps are fine — not all material needs a chapter.

For worked examples in unrelated domains, see [examples.md](examples.md).
