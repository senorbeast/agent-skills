# Agent Skills

Agent-agnostic source of truth for personal and installed agent skills.

## Layout

- `AGENTS.md` is the tracked copy of the global Codex guidance currently used at `/home/beasty/.codex/AGENTS.md`.
- `skills/` contains real skill directories.
- Agent-specific skill folders should symlink into `skills/` instead of storing separate copies.
- `.skill-lock.json` tracks skills installed by `npx skills@latest`.

## Linked Agent Roots

- Codex: `/home/beasty/.codex/skills`
- Claude: `/home/beasty/.claude/skills`
- Pi: `/home/beasty/.pi/agent/skills`

Keep generated app state, auth files, logs, and model caches out of this repo.
