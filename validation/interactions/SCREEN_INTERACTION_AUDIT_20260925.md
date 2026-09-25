# ActiRune Screen Interaction Audit — 2026-09-25

## Scope

This audit covers every `lib/features/**/*_screen.dart` file plus MainShell-owned artwork popups. It distinguishes real production navigation from controlled fail-closed actions, external blockers, and source files that intentionally have no production entry route yet.

The machine-readable source of truth is `validation/interactions/screen_reachability.json`. `tool/interaction_audit.py` fails CI if a screen is added/removed without classification, if a production screen loses its owner, if an authority-blocked screen leaks into production roots, or if a reachable/Battle screen has no test reference.

## Inventory summary

| Classification | Count | Meaning |
| --- | ---: | --- |
| `production_route` | 26 | Reachable from `MainShell`; visible optional controls are wired to a real route/action or explicit fail-closed feedback. |
| `onboarding_route` | 5 | Reachable through the `/onboarding` phase flow and real first-calibration route. |
| `external_blocker` | 7 | Canonical Battle subtree exists and is tested, but production does not inject a Battle encounter builder before encounter/content authority exists. |
| `authority_blocked` | 4 | Approved/implemented shell exists, but required state/engine/entitlement/reward authority does not exist yet; no fake production route is created. |
| `legacy_unrouted` | 1 | Old generic `QuestsScreen`; canonical production uses Daily/Weekly/Quest Chain screens instead. |
| **Total** | **43** | All current feature screen source files are classified. |

MainShell artwork ownership also covers `DailySummaryPopup` and `EventDetailPopup`, which are not named `*_screen.dart`.

## Production wiring corrections made in this branch

- Connected previously null MainShell callbacks across Home, Adventure, Hero, Profile, Equipment, Inventory, Lumi, Movement Mastery, Player Level, Achievements, Settings, Shop and related child flows.
- Replaced silent dead hotspots with `FeatureUnavailableDialog` only where no authoritative destination/owner exists.
- Fixed the incorrect Hero Character Story wiring that previously routed to Quest Chain.
- Preserved real routes where they exist instead of replacing them with generic fallback dialogs.
- Connected Settings Permissions `Manage` actions to the app-settings platform launcher.
- Wired onboarding Language and Accessibility controls to visible fail-closed feedback instead of null callbacks.
- Kept Battle unavailable from the production `/app` root until a real encounter/content owner is supplied.
- Hardened `BattleScreen`, the canonical encounter route adapter, so nullable external owner actions no longer become silent no-ops. Missing equipment/runes/companion/abilities/tips/info/recheck/replay/rewards/tactics/rewarded-retry owners now fail closed visibly.
- Added a production interaction regression suite and a Python source-level audit.

## Route groups

### Production MainShell

`HomeScreen`, `AdventureScreen`, `WorldProgressionScreen`, `EquipmentScreen`, `HeroScreen`, `InventoryScreen`, `LumiScreen`, `MovementMasteryScreen`, `EventsScreen`, `HomeScreen`, `RuneShrineReadyScreen`, `AchievementsScreen`, `PlayerLevelScreen`, `ProfileHistoryScreen`, `ProfileScreen`, all six Settings screens, `DailyQuestsScreen`, `QuestChainScreen`, `WeeklyQuestsScreen`, `ProPaywallScreen`, `ShopScreen`, and `SocialScreen`.

`SocialScreen` is routable from Profile → Friends but remains a generic placeholder layout. The approved social visual family is not represented by a complete production implementation yet. This is an implementation gap, not a navigation bug.

### Onboarding

`OnboardingScreen` → `OnboardingWelcomeScreen` → `FirstCalibrationScreen` → real `FirstCalibrationFlowScreen` → `CalibrationResultScreen` → `/app`.

The calibration result is shown only after the typed assessment reports a ready starting profile; the audit does not fabricate successful calibration.

### Battle, externally blocked from production

`BattleScreen`, `BattlePrepScreen`, `CameraPrepScreen`, `LiveBattleScreen`, `FormCoachScreen`, `VictoryScreen`, and `DefeatScreen` form the canonical tested encounter subtree.

Production `ActiRuneApp` currently constructs `const MainShell()` with no `battleRootBuilder`. This is deliberate. The first real Battle encounter/content authority is still external, so production Battle selection must remain visibly locked rather than inventing an encounter.

### Authority-blocked screens

- `PersonalDailyAdventureScreen`: requires authoritative personalized targets, recovery/plan data, encounter ownership and reward ownership.
- `CraftingScreen`: requires authoritative inventory spend, material source, crafting result and item grant ownership.
- `RuneShrineResultScreen`: source explicitly states that the authoritative shrine cooldown/reward engine and proven parent entry route do not exist yet.
- `ProFormCoachScreen`: requires authoritative long-term analytics and Pro entitlement ownership.

These screens are intentionally not connected to an arbitrary production button. Doing so would make navigation appear complete while fabricating product behavior.

### Legacy

`QuestsScreen` is a generic old scaffold. Production uses `DailyQuestsScreen`, `WeeklyQuestsScreen`, and `QuestChainScreen`; the legacy scaffold remains classified so it cannot silently become a new production route.

## CI gates

The branch workflow `ActiRune UI Interaction Validation` is read-only and strict. It runs:

1. `python3 tool/interaction_audit.py`
2. `dart format --output=none --set-exit-if-changed lib test`
3. `flutter analyze`
4. `flutter test --no-pub test/production_interaction_wiring_test.dart`
5. `flutter test --no-pub`
6. `git diff --check`

The Python gate checks MainShell callback contracts, complete screen classification, production owner reachability, authority-blocked isolation, onboarding ownership, Battle production lock, Battle adapter fail-closed behavior, and test-reference evidence.

## Remaining non-navigation blockers

The audit does **not** claim the following external/product-authority items are complete:

- final Android/iOS application identity,
- real signing,
- provider authority/configuration,
- first real Battle encounter/content authority,
- physical-device ML Kit evidence,
- exact release-candidate gate evidence,
- store submission/review evidence.

It also does not promote the placeholder Social implementation or the four authority-blocked shells into fake completed product features.
