---
name: skill-link
description: >-
  Manage a skills library (me/ and vendor/), move npx installs into vendor, and
  symlink skills into a project-local .agents/skills. Use when setting up the
  skills workspace, linking or unlinking a skill in a project, or moving a skill
  from ~/.agents/skills into vendor. Commands: skill-setup, skill-move,
  skill-link, skill-unlink.
---

# skill-link

Keep skill sources in a library (`me/` for owned skills, `vendor/` for third-party). Activate a skill in a project by symlinking it into that project’s `.agents/skills`. Do not install skills into the global `~/.agents/skills` for long-term use.

This skill’s name and the link command are both `skill-link`.

Let `$SKILL_DIR` be the directory containing this `SKILL.md`. Always run the scripts below from there. Do not install commands onto `PATH` or into `~/.local/bin`.

## One-time setup

The library path is required. Ask the user for it if they have not given one. Do not guess or search for it. If the path is missing, stop and ask — do not run setup.

```bash
"$SKILL_DIR/scripts/setup.sh" <workspace-root>
```

Writes `$SKILL_DIR/library-root` (absolute library path, gitignored) and creates `vendor/`.

## Commands

```bash
"$SKILL_DIR/scripts/setup.sh" <workspace-root>
"$SKILL_DIR/scripts/move.sh" <skill-name>
"$SKILL_DIR/scripts/link.sh" <skill-name> [project-dir]
"$SKILL_DIR/scripts/unlink.sh" <skill-name> [project-dir]
```

Agent shorthand (same operations): `skill-setup`, `skill-move`, `skill-link`, `skill-unlink` — always expand to the script paths above.

- `setup` — record library root; create `vendor/`
- `move` — move `~/.agents/skills/<name>` into `<library>/vendor/<name>` (after `npx skills add`)
- `link` — symlink from `me/<name>` or `vendor/<name>` into `<project>/.agents/skills/<name>` (`project-dir` defaults to cwd)
- `unlink` — remove that project symlink only; never deletes library content

Resolution for link: prefer `me/<name>`, else `vendor/<name>`.

## Missing skills

If there is no exact match in `me/` or `vendor/`, list the skill directories in those two places and suggest close local names (substring or similar spelling). Ask which to link, if any. Do not link a suggestion without confirmation.

Never search skills.sh, never suggest remote packages, never run `npx skills find` / `npx skills add`, and never compare install counts. Suggestions must come only from the local library.

## Typical flow

```bash
npx skills add <package>
"$SKILL_DIR/scripts/move.sh" <skill-name>
"$SKILL_DIR/scripts/link.sh" <skill-name>
```

Owned skills in `me/` skip move:

```bash
"$SKILL_DIR/scripts/link.sh" extract-audio
"$SKILL_DIR/scripts/unlink.sh" extract-audio
```
