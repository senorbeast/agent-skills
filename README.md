# Agent Skills

Agent-agnostic source of truth for personal and installed agent skills.

## One-Line Install

### Linux/macOS
Clone or update this repo at `~/.agents` and link global guidance:

```bash
curl -fsSL https://raw.githubusercontent.com/senorbeast/agent-skills/main/install.sh | bash
```

### Windows
Clone or update this repo at `~\.agents` and link global guidance:

```powershell
Invoke-RestMethod -Uri https://raw.githubusercontent.com/senorbeast/agent-skills/main/install.ps1 | Invoke-Expression
```

## Layout

- `AGENTS.md` is the tracked copy of global agent guidance.
- `skills/` contains real skill directories.
- `install.sh` and `install.ps1` setup symlinks and configurations.
- `.skill-lock.json` tracks skills installed by `npx skills@latest`.

## Working With `npx skills`

This repo intentionally uses the same root that `npx skills@latest` uses:

```text
~/.agents
```

Use `npx skills@latest` as the authority for installing skills and creating symlinks for supported agents. This repo versions the resulting `~/.agents` directory; it does not replace the interactive TUI.

Expected setup workflow:

```bash
# First, register this repo as the global skills source and choose skills/agents interactively
npx skills@latest add ~/.agents -g --full-depth

# Then install or update Matt Pocock skills and choose agent symlink targets in the TUI
npx skills@latest add mattpocock/skills -g

# Version the resulting skills and lockfile
cd ~/.agents
git status
git add skills .skill-lock.json
git commit -m "Update installed skills"
git push
```

In this setup:

- `npx skills@latest` owns installing/updating external skills.
- `npx skills@latest` owns broad multi-agent symlink setup.
- This Git repo owns syncing your `~/.agents` files across machines.

Do not clone this repo somewhere else while also letting `npx skills` manage `~/.agents`; that creates two sources of truth.

## Global Guidance & Skill Auto-Discovery

### Google Antigravity / Gemini
The installer automatically sets up Google Antigravity by linking the global guidance and creating `skills.json`:
- Links `~/.gemini/config/AGENTS.md` -> `~/.agents/AGENTS.md`.
- Creates `~/.gemini/config/skills.json` pointing to `~/.agents/skills` to automatically load all skills without individual symlinks.

### Codex
Codex reads global guidance from `~/.codex/AGENTS.md`. The installer links that file to this repo:

```bash
~/.codex/AGENTS.md -> ~/.agents/AGENTS.md
```

### Claude Code
Claude Code commonly uses `~/.claude/CLAUDE.md` for user-level guidance. To share the same tracked guidance file with Claude:

```bash
mkdir -p ~/.claude
if [ -e ~/.claude/CLAUDE.md ] && [ ! -L ~/.claude/CLAUDE.md ]; then
  mv ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.backup.$(date +%Y%m%d%H%M%S)
fi
ln -sfn ../.agents/AGENTS.md ~/.claude/CLAUDE.md
```

### Pi
Pi discovers `AGENTS.md` and `CLAUDE.md` context files, but this install has no documented Pi-specific global guidance file. Use one of these approaches:

```bash
# Per project
ln -s ~/.agents/AGENTS.md ./AGENTS.md

# Per invocation
pi --append-system-prompt ~/.agents/AGENTS.md
```


## Sync Symlinks

Prefer `npx skills@latest` for symlink setup because it supports more agents and has an interactive TUI.

This repo still includes a conservative fallback script for Codex, Claude, and Pi only:

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
