# ActiRune Runtime Visual Authority — 2026-09-24

Branch authority: `integration/artwork-interactions-20260921`

## Purpose

This record prevents selected visual candidates from being silently described as canonical production authority and prevents runtime code from drifting back to superseded, legacy, patch-base or near-final reference folders.

## Authority rule

Runtime artwork may come from:

1. `current/01_CANONICAL_FINAL` and `current/02_CORE_LOCKED_ANCHORS` when the visual-authority manifest classifies that screen as canonical/locked;
2. the approved final P0 battle package for its locked battle screens;
3. the selected-final packages below only as explicit runtime-reference exceptions while their package manifests still stop short of canonical promotion.

A filename containing `FINAL` is not by itself an authority promotion. Package README/manifest status controls.

## Explicit runtime-reference exceptions

### `final_p1`

The package manifest marks every entry `SELECTED_P1_VISUAL_AUTHORITY_CANDIDATE`. Runtime currently uses the following selected candidates because they are the newest user-targeted screen revisions and the older sources are only patch/near-final references:

- `02_P1_EQUIPMENT_FINAL.png`
- `03_P1_INVENTORY_FINAL.png`
- `04_P1_CRAFTING_FINAL.png`
- `05_P1_MOVEMENT_MASTERY_FINAL.png`
- `06_P1_PLAYER_LEVEL_FINAL.png`
- `07_P1_SETTINGS_HUB_FINAL.png`

This exception is not a canonical promotion. `01_P1_PROFILE_FINAL_REVISION.png` is not runtime authority while the canonical Profile shell `current/01_CANONICAL_FINAL/VIS_0222__P1_PROFILE_FINAL.png` remains the repository's explicit canonical Profile authority.

### `final_remaining_13`

These selected finals are allowed as runtime production-reference/final-candidate assets for the 13 explicitly selected screen families recorded by that package. Their package README still describes them as production visual reference/final candidates, so runtime use must not be reported as a blanket canonical promotion.

### `final_p0_battle`

The selected P0 battle package remains the runtime authority for the battle screens already guarded by Direct Validation. Any file whose own package status remains candidate must retain that qualifier; CI presence/dimension checks do not promote it.

## Forbidden runtime source classes

Production runtime code under `lib/` must not point directly at:

- `current/03_NEAR_FINAL_REFERENCES/`
- `current/04_CAMERA_PREP_REFERENCE_PAIR/`
- `current/05_CURRENT_PATCH_REFERENCES/`
- `current/07_CURRENT_SUPERSEDED_BY_FINAL/`
- `current/08_LEGACY_FUNCTION_REFERENCE_ONLY/`

Those locations remain comparison, patch, historical or function-only evidence.

## CI terminology note

The existing Direct Validation steps named `Guard canonical artwork presence` and `Inspect canonical artwork dimensions` verify required runtime artwork bytes and dimensions. They do **not** promote a selected candidate to canonical authority. Authority comes from the visual package/manifest and explicit owner decisions, not from a CI step name.

## Route authority boundary

Existence of a visual does not create a runtime route. Shop, Pro Paywall, Personal Daily Adventure, Pro Form Coach, Crafting and other child screens must only be bound when an approved parent entry/hotspot or product-domain owner provides an unambiguous route. P1-005 deliberately avoided inventing parent routes; this visual record does not change that rule.

## Reopening rule

A candidate can be promoted, replaced or demoted only by a new explicit owner decision or stronger repository authority. Do not infer promotion from filename, runtime use, CI green status, or elapsed time.
