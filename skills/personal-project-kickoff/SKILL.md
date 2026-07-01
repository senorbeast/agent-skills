---
name: personal-project-kickoff
description: Plans new apps, repos, product ideas, and substantial features using the user's preferred contextual planning flow. Use when starting a new project, shaping a product idea, creating a repo, planning a large feature, or deciding whether to use grill-with-docs, triage, PRD, or issue slicing.
---

# Personal Project Kickoff

## Default posture

Start by discovering the current repo state before asking questions. Read existing `AGENTS.md`, `CONTEXT.md`, `CONTEXT-MAP.md`, `docs/adr/`, `docs/agents/`, package manifests, and obvious entrypoints when present.

Use the lightest process that will produce a clear next implementation step:

- Small, concrete change: plan or implement the smallest useful vertical slice.
- New app, product idea, or ambiguous feature: clarify the goal, success criteria, audience, scope, and key constraints.
- Large or domain-heavy project: use `grill-with-docs` to sharpen language and decisions, then `triage`, `to-prd`, and `to-issues` when issue-tracker-backed planning is useful.

## Per-repo setup

If the repo lacks Matt Pocock-style agent setup, run or recommend `setup-matt-pocock-skills` before using `triage`, `to-prd`, or `to-issues`.

During setup, ask which issue tracker this repo uses. Do not assume a global tracker. Valid defaults to offer are GitHub Issues, local markdown, GitLab Issues, or a user-described tracker.

Keep project rules project-local:

- `AGENTS.md` for durable repo instructions
- `CONTEXT.md` for domain glossary only
- `docs/adr/` for hard-to-reverse architectural decisions
- `docs/agents/*` for issue tracker, triage labels, and domain-doc routing

## Output shape

For kickoff output, prefer:

1. A concise goal statement
2. The first thin vertical slice
3. Any necessary project setup
4. Verification commands
5. Open decisions that block implementation

Do not create a heavyweight PRD or issue set for small, obvious work unless the user asks.
