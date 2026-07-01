# Global Codex Guidance

## Working Style

- Prefer thin vertical slices: build one small user-visible capability through the backend, frontend, shared contracts, and tests before moving to the next feature.
- Use the repository's existing patterns first. Add new abstractions only when they remove real complexity or match an established local convention.
- Keep required project rules in checked-in `AGENTS.md`, `CONTEXT.md`, ADRs, and `docs/agents/*`. Treat generated memories as helpful recall, not as the source of truth for mandatory behavior.
- When a project is big, ambiguous, or domain-heavy, use the Matt Pocock-style flow contextually: `grill-with-docs` -> `triage` -> `to-prd` -> `to-issues`. For small changes, go straight to the smallest useful vertical slice.
- Ask per project which issue tracker to use. Do not assume a global default issue tracker.

## Preferred Stack

- Backend defaults: Python, FastAPI official templates, FastAPI fullstack template when appropriate, Pydantic, Alembic, strict typing, `uv`, and `ruff`.
- Frontend defaults: React with Vite or Next.js, Tailwind, and shadcn based on the project.
- Fullstack defaults: shared API contracts and generated frontend clients where useful, especially `hey-api`, TanStack Query hooks, and Zod/runtime validators.

## Personal Skills

- Use `personal-project-kickoff` when starting a new app, repo, product idea, or substantial feature.
- Use `personal-fullstack-slice` for FastAPI, React, Next.js, Vite, shared contracts, or fullstack feature work.
