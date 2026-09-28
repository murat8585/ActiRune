# 07 — RUNTIME / ROUTE RECOVERY + VALIDATION HISTORY

## 2026-09-26 runtime recovery matrix
Production/audit context recorded:
- TOTAL_CONTROLS = 492
- FULLY_WORKING = 185
- BROKEN_OR_PREVIEW = 307
- PREVIEW_ONLY = 41
- FEATURE_UNAVAILABLE = 136
- WRONG_ROUTE = 2
- STATE_DISCONNECTED = 18
- ENGINE_DISCONNECTED = 3
- UNREACHABLE = 102
- STATIC_ARTWORK_ONLY = 5
- REAL_NAVIGATION = 170
- REAL_LOCAL_STATE = 10
- REAL_SYSTEM_ACTION = 5

Donor classification:
- DIRECT_DONOR = 137
- ADAPTABLE_DONOR = 223
- SUPERSEDED_DONOR = 28
- UNSAFE_DONOR = 33
- NO_DONOR = 71

Important interpretation:
This was a static source / prior manual-observation audit, NOT a fresh emulator PASS. A route entering a preview or unavailable dialog was considered broken. A donor source existing does not prove a downstream feature works.

Known visual/runtime route examples from the audit:
- R-01 Home -> VIS_0354 -> `home_screen`
- R-02 Adventure -> VIS_0231 -> `adventure_screen`
- R-03 Battle root -> VIS_0166/patch family
- R-04 Hero main -> VIS_0171
- R-05 Profile main -> `01_P1_PROFILE_FINAL_REVISION`
- R-06 Daily Quests -> VIS_0227

Historical authority order used in audit:
latest user instruction > matching current final visual package > 20260919 route map/manifest > donor implementation > historical layout.

## Earlier toolchain/build context
- Flutter 3.44.6
- Dart 3.12 family
- Android debug APK had built in earlier development
- Android camera + ML Kit source/build path had been validated
- iOS deployment target moved to 15.5 for ML Kit compatibility

## Emulator validation snapshot before final 60 clean-base integration
Known prior validation:
- production head: `95d7a83...`
- validation branch: `validation/emulator-20260924`
- validation head: `1e8cb87...`
- package: `com.example.actirune`
- version: `0.1.0`
- versionCode: `1`
- Pixel 8 / Android 17 API 37 x86_64 emulator
- install PASS
- cold launch PASS
- first screen opened
- no crash

Not covered by that validation:
- final 60 clean-base integration
- full battle path
- full auth/provider path

Therefore no fresh emulator PASS exists yet for the current final-visual integration work.

## Current validation definition
Do not claim current integration PASS until after:
1. 60 canonical asset mapping is verified
2. correct asset directory exists on integration branch
3. first routes are wired
4. Flutter analyze/test passes
5. emulator cold launch + navigation + battle/camera smoke is performed
6. no asset/hotspot misalignment is observed

## Functional priority after visual integration
Use the runtime matrix to close:
- preview-only actions
- feature-unavailable placeholders
- wrong routes
- state-disconnected controls
- engine-disconnected controls
- unreachable widgets
- static-artwork-only pseudo features

Core loop closure takes priority over polishing distant optional screens.
