# Contracts And hey-api Reference

## Goal

Keep backend and frontend contracts explicit, reproducible, and type-safe. Prefer generated clients over hand-maintained DTO duplication when the project can support it.

## Defaults

- Use FastAPI OpenAPI as the source of truth for HTTP contracts unless the repo already uses another schema-first workflow.
- Use `hey-api` for generated frontend API clients when appropriate.
- Generate TanStack Query hooks when the frontend uses TanStack Query.
- Generate or maintain Zod/runtime validators when runtime validation is needed at frontend boundaries.

## Workflow

1. Update backend Pydantic models and route response/request contracts.
2. Confirm OpenAPI output reflects the intended contract.
3. Regenerate frontend client code using the project's configured command.
4. Use generated types/hooks in the UI instead of duplicating DTOs by hand.
5. Include generated-code verification in the slice when the repo supports it.

## Rules

- Do not manually edit generated client files unless the repo explicitly does so.
- Keep generation commands documented in repo scripts or `AGENTS.md`.
- If generated code changes unexpectedly, inspect the OpenAPI diff before patching frontend usage.
- Treat breaking API changes as fullstack changes: backend, generated contracts, frontend usage, and tests move together.
