---
name: personal-fullstack-slice
description: Guides FastAPI, React, Next.js, Vite, API contract, hey-api, TanStack Query, Zod, and fullstack feature work in thin vertical slices. Use when building or planning FastAPI backends, React frontends, shared DTOs/contracts, generated frontend clients, or end-to-end feature slices.
---

# Personal Fullstack Slice

## Slice rhythm

Build one user-visible capability at a time. A good slice may touch schema, migration, API route, DTOs, generated client, UI, and tests, but it should stay narrow enough to verify quickly.

Before implementing, inspect the repo and follow its local conventions. Prefer existing project scripts and patterns over generic defaults.

## Reference routing

Read only the references needed for the current slice:

- FastAPI backend, Pydantic, Alembic, `uv`, `ruff`, typing: [backend-fastapi.md](references/backend-fastapi.md)
- React, Vite, Next.js, Tailwind, shadcn: [frontend-react.md](references/frontend-react.md)
- Shared DTOs, OpenAPI, `hey-api`, TanStack Query, Zod/runtime validators: [contracts-hey-api.md](references/contracts-hey-api.md)
- Vertical slicing, test strategy, verification: [testing-and-slices.md](references/testing-and-slices.md)

## Working rules

- Keep API contracts explicit and generated clients reproducible.
- Prefer strict typing on both sides of the stack.
- Test through public behavior and the highest useful seam.
- After each slice, run the smallest meaningful verification command before continuing.
- If the repo lacks scripts or conventions, propose minimal ones rather than inventing a large framework.
