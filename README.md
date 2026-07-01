# Agent Skills

Agent-agnostic source of truth for personal and installed agent skills.

## One-Line Install

Set up this repo, global Codex guidance, and skill symlinks for Codex, Claude, and Pi:

```bash
curl -fsSL https://raw.githubusercontent.com/senorbeast/agent-skills/main/install.sh | bash
```

## Layout

- `AGENTS.md` is the tracked copy of the global Codex guidance currently used at `/home/beasty/.codex/AGENTS.md`.
- `skills/` contains real skill directories.
- Agent-specific skill folders should symlink into `skills/` instead of storing separate copies.
- `.skill-lock.json` tracks skills installed by `npx skills@latest`.

## Linked Agent Roots

- Codex: `/home/beasty/.codex/skills`
- Claude: `/home/beasty/.claude/skills`
- Pi: `/home/beasty/.pi/agent/skills`

## Sync Symlinks

Run this after cloning or updating the repo:

```bash
scripts/sync-skill-symlinks.sh
```

Preview changes without writing:

```bash
scripts/sync-skill-symlinks.sh --dry-run
```

Skip linking global Codex guidance during install:

```bash
curl -fsSL https://raw.githubusercontent.com/senorbeast/agent-skills/main/install.sh | SYNC_GLOBAL_AGENTS=0 bash
```

Keep generated app state, auth files, logs, and model caches out of this repo.
