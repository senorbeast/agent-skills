# Agent Skills

Agent-agnostic source of truth for personal and installed agent skills.

## One-Line Install

Set up this repo, global Codex guidance, and skill symlinks for Codex, Claude, and Pi:

```bash
curl -fsSL https://raw.githubusercontent.com/senorbeast/agent-skills/main/install.sh | bash
```

## Layout

- `AGENTS.md` is the tracked copy of global agent guidance.
- `skills/` contains real skill directories.
- Agent-specific skill folders should symlink into `skills/` instead of storing separate copies.
- `.skill-lock.json` tracks skills installed by `npx skills@latest`.

## Linked Agent Roots

- Codex: `~/.codex/skills`
- Claude: `~/.claude/skills`
- Pi: `~/.pi/agent/skills`

## Global Guidance

Codex reads global guidance from `~/.codex/AGENTS.md`. The installer links that file to this repo:

```bash
~/.codex/AGENTS.md -> ~/.agents/AGENTS.md
```

Claude Code commonly uses `~/.claude/CLAUDE.md` for user-level guidance. To share the same tracked guidance file with Claude:

```bash
mkdir -p ~/.claude
if [ -e ~/.claude/CLAUDE.md ] && [ ! -L ~/.claude/CLAUDE.md ]; then
  mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)
fi
ln -sfn ../.agents/AGENTS.md ~/.claude/CLAUDE.md
```

Pi discovers `AGENTS.md` and `CLAUDE.md` context files, but this install has no documented Pi-specific global guidance file. Use one of these approaches:

```bash
# Per project
ln -s ~/.agents/AGENTS.md ./AGENTS.md

# Per invocation
pi --append-system-prompt ~/.agents/AGENTS.md
```

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
