# Frontend React Reference

## Defaults

- Use React with Vite for focused frontend apps and Next.js when routing, server rendering, app-router conventions, or fullstack framework benefits matter.
- Use Tailwind for styling and shadcn when the project wants composable app UI primitives.
- Follow the existing design system and file layout when working in an existing repo.

## Component shape

- Keep route/page components focused on composition, data loading, and state boundaries.
- Put reusable UI in components that match the project's design system.
- Prefer generated API hooks/clients over hand-written fetch code when the project has contract generation.
- Represent loading, empty, error, and success states for user-facing data.

## UI behavior

- Build the usable workflow first, not a marketing shell.
- Keep dense operational tools quiet, scannable, and efficient.
- Use accessible controls and visible state. Prefer shadcn components where they already fit.
- Avoid adding broad UI abstractions until repeated usage justifies them.

## Verification

- Use existing scripts first.
- Typical checks: lint, typecheck, tests, and a browser smoke test for meaningful UI changes.
- For visual or interaction-heavy work, verify at desktop and mobile widths.
