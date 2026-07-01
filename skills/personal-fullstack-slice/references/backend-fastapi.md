# Backend FastAPI Reference

## Defaults

- Prefer the official FastAPI template or FastAPI fullstack template for new apps unless the project has stronger local constraints.
- Use `uv` for Python environment and dependency management when starting fresh.
- Use `ruff` for linting and formatting.
- Use strict typing: typed function signatures, Pydantic models at boundaries, and explicit return types for application code.
- Use Alembic for database migrations.

## FastAPI shape

- Keep routes thin: parse inputs, call application logic, return typed responses.
- Put domain/application behavior behind small, testable interfaces instead of embedding it in route handlers.
- Use Pydantic request and response models for external API shape.
- Prefer dependency injection for request-scoped resources such as sessions, auth context, and settings.
- Keep error responses consistent and documented in OpenAPI when they are part of the contract.

## Database and migrations

- Add Alembic migrations in the same vertical slice as schema-dependent behavior.
- Keep migrations reversible when practical, but prioritize accurate forward migrations.
- Avoid schema drift: models, migrations, and API behavior should be updated together.

## Verification

- Prefer existing commands from the repo.
- Typical checks for a fresh project: `uv run ruff check`, `uv run ruff format --check`, type checking if configured, and backend tests.
- For API behavior, prefer integration tests through FastAPI's test client or the project's highest public backend seam.
