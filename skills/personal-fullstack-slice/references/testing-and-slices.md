# Testing And Vertical Slices Reference

## Thin vertical slices

A slice should deliver one narrow behavior that can be demonstrated or verified end-to-end. Prefer several small slices over one broad pass.

Typical fullstack slice order:

1. Define the user-visible behavior.
2. Identify the contract and data shape.
3. Update backend behavior and persistence if needed.
4. Regenerate or update frontend contract bindings.
5. Build the smallest UI path.
6. Add or update tests through public seams.
7. Run the smallest meaningful verification set.

## Testing posture

- Prefer behavior tests over implementation tests.
- Use the highest useful seam: API tests for backend behavior, component/page tests for UI behavior, and end-to-end tests only when they buy confidence across integration points.
- Avoid mocking internals. Mock external services and slow boundaries when needed.
- Keep tests close to the slice and name them by behavior.

## Verification checklist

- Backend changed: run lint, formatting check, type check if configured, migrations checks if applicable, and relevant tests.
- Frontend changed: run lint, typecheck, relevant tests, and browser smoke checks when UI behavior changed.
- Contracts changed: regenerate clients and confirm no stale generated output remains.
- Fullstack behavior changed: verify at least one path from user action to backend response or persisted state.
