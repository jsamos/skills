# skill-link

Manage a skills library and activate skills in a project via symlinks.

## What it manages

| Place | Role |
| --- | --- |
| Library (`me/` + `vendor/`) | Where skill sources live. `me/` is yours; `vendor/` is third-party. |
| Staging (`~/.agents/skills`) | Temporary land from `npx skills add`. |
| Project (`.agents/skills`) | Symlinks so the agent in that project can see a skill. |

## How to use it

Once, give your library root (the folder that contains `me/`):

- “Set up skill-link with library `/path/to/skills`”

Then:

- “Link `extract-audio` into this project”
- “Move `find-skills` into vendor, then link it”
- “Unlink `extract-audio` from this project”

If a name isn’t exact, the skill suggests close matches from `me/` / `vendor/`.

### Typical flows

**Owned skill (already in `me/`):** link it into the project.

**Skill from npx:** `npx skills add …`, then move it into `vendor/` and link it.

### Unlink

Unlink only removes the project symlink. It does not delete anything under `me/` or `vendor/`.

## Notes

- Prefer project-local `.agents/skills` links over leaving skills installed globally.
- Link resolves `me/<name>` first, then `vendor/<name>`.
