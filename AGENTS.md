# AGENTS.md

## Scope
These instructions apply to the repository root and all subdirectories unless a deeper AGENTS.md overrides them.

## Product authority
- Follow `ACTIRUNE_PRODUCT_AUTHORITY.md`.
- Do not invent product behavior, providers, identifiers, pricing, rewards, backend authority, or production evidence.
- Preserve fail-closed behavior where production authority is missing.

## Change discipline
- Keep changes scoped to the authorized task.
- Preserve existing runtime behavior unless the task explicitly changes it.
- Do not weaken tests, validation gates, or release checks to make a change pass.
- Do not treat generated or placeholder content as production authority.

## Flutter
- Run formatting/analyzer/tests when the environment permits.
- Keep artwork-driven screens aligned with their approved visual authority and interaction contracts.
- Prefer existing shared widgets and navigation contracts over parallel implementations.

## Evidence
- Distinguish internal validation from production readiness.
- Never fabricate physical-device, store, signing, billing, ad-provider, analytics, or backend proof.
