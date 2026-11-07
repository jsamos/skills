# skill-link

Manage a local skills library and activate skills in projects via symlinks.

The skill name and the link command are both `skill-link`.

## Model

| Place | Path | Role |
| --- | --- | --- |
| Library | configured via setup | Source of truth: `me/` (owned) and `vendor/` (third-party) |
| Staging | `~/.agents/skills/<name>` | Temporary land from `npx skills add` |
| Project | `<project>/.agents/skills/<name>` | Symlink so an agent in that project can use the skill |

Flow: `npx skills add` → move into `vendor/` → link into a project. Owned skills in `me/` skip move and only need link.

## One-time setup

You must pass the library root (the directory that contains `me/`):

```bash
./me/skill-link/scripts/setup.sh /path/to/skills
```

This writes `library-root` inside this skill directory (gitignored absolute path) and creates `vendor/`. It does not install anything onto `PATH`.

## Commands

Run scripts from this skill’s `scripts/` directory:

```bash
scripts/setup.sh <workspace-root>
scripts/move.sh <skill-name>
scripts/link.sh <skill-name> [project-dir]
scripts/unlink.sh <skill-name> [project-dir]
```

`project-dir` defaults to the current working directory.

### Examples

```bash
./scripts/setup.sh /path/to/skills
./scripts/move.sh find-skills
./scripts/link.sh find-skills
./scripts/link.sh extract-audio
./scripts/link.sh extract-audio /path/to/some-app
./scripts/unlink.sh extract-audio
```

`link` resolves `me/<name>` first, then `vendor/<name>`.

`unlink` removes only the project symlink. It never deletes anything under `me/` or `vendor/`.

## Agent skill

`SKILL.md` tells an agent how to run these scripts. Keep this folder at `me/skill-link` in the library.
