# ActiRune — Ana Dünya Interaction + Engine Audit

Date: 2026-09-25
Branch: `fix/full-ui-interaction-wiring-20260925`
Validated source HEAD before this evidence commit: `1b059ec72220fb9fa430bc28d1034815eeaed647`
Validation run: `36147004762`

## Result

`PASS_WITH_EXPLICIT_EXTERNAL_BLOCKERS`

The Ana Dünya interaction/navigation layer is validated. This result does **not** claim that every visible product value is backed by a live persistence/provider engine. Those boundaries are listed explicitly below.

## Ana Dünya interaction matrix

| Control | Production outcome | Interaction status | Engine/data status |
| --- | --- | --- | --- |
| Günlük Seri | Opens Daily Quests | PASS | BLOCKED/PARTIAL — Product Bible defines a separate locked 7-day flexible streak system, but no dedicated streak engine, persistence owner, or dedicated streak screen is present. Daily Quests is currently the nearest existing product surface, not proof of a live streak engine. |
| Mesajlar | Explicit `Rune Gelen Kutusu` unavailable response | PASS | BLOCKED — no production inbox/message screen or message engine found. |
| Görevler | Opens Weekly Quests | PASS | PARTIAL — Daily/Weekly quest policy engines exist and tests pass; artwork screens are not wired to an authoritative persisted quest/reward mutation owner. Reward/task-change mutations remain fail-closed. |
| Etkinlikler | Opens Events; featured/list event opens Event Detail popup | PASS | BLOCKED/PARTIAL — interaction UI exists; no authoritative event engine/repository/state owner found. Join/tasks remain explicit unavailable rather than fake success. |
| Ayarlar | Opens Settings Hub and child sections | PASS | PARTIAL — Permissions manage action uses the platform app-settings launcher; most account/notification/privacy/accessibility mutations have no persistence owner and therefore return explicit unavailable feedback. |
| Dünya Haritası | Opens World Progression | PASS | PARTIAL — progression policy exists and passes tests; region/node/boss/reward runtime state, thresholds, and persistence owner are not connected. |
| Dünün Özeti | Opens Daily Summary popup; close/continue/adventure routing works | PASS | BLOCKED/PARTIAL — summary is canonical static artwork; no live summary-data owner is connected. |
| Ödüller | Opens Rune Shrine Ready | PASS | PARTIAL/EXTERNAL — rewarded-ad policy and provider contracts are tested; no authorized live ad provider + persistent reward history/grant owner is connected, so gift grant remains fail-closed. |
| Ana Dünya tab | Remains/returns to Home | PASS | N/A |
| Macera tab | Opens Adventure root | PASS | N/A |
| Savaş tab | Explicit locked response when no real encounter authority is supplied | PASS | EXTERNAL_BLOCKED — no fake encounter is created. |
| Kahraman tab | Opens Hero root | PASS | N/A |
| Profil tab | Opens Profile root | PASS | N/A |

## Child-screen interaction coverage

Validated Home subtree includes:

- Daily Quests
- Weekly Quests
- Events
- Event Detail popup
- World Progression
- Daily Summary popup
- Rune Shrine Ready
- Settings Hub
- Account
- Notifications
- Privacy
- Permissions
- Accessibility
- root navigation from the above child screens
- controlled Battle lock behavior where real encounter authority is absent

No visually actionable Home-subtree control is allowed to fail silently in the validated production composition. Where an authoritative route/engine is absent, the interaction gives an explicit unavailable/locked response instead of swallowing the tap.

## Engine audit

### Quest engines

Status: `POLICY_PASS_INTEGRATION_PARTIAL`

- Daily quest plan/milestone policy exists.
- Weekly quest policy exists.
- Reward-claim idempotency policy exists.
- Tests pass.
- Persistence and actual economy reward application remain caller-owned.
- Daily/Weekly artwork screens do not currently render authoritative live plan/state data.

### 7-day flexible streak

Status: `MISSING_RUNTIME_OWNER`

The Product Bible defines this as a separate LOCKED system. No dedicated runtime streak engine/persistence owner was found. No fake streak state was added during this audit.

### World progression

Status: `POLICY_PASS_INTEGRATION_PARTIAL`

- Progression policy exists and passes tests.
- Movement Mastery authorization is protected by verified-movement evidence.
- Live world-node/region/boss progression and persistence are not connected to the artwork screen.

### Rune Shrine / rewarded ads

Status: `POLICY_AND_CONTRACT_PASS_EXTERNAL_PROVIDER_BLOCKED`

- Rune Shrine cooldown policy: 4 hours.
- Daily successful reward limit: 3.
- Free path requires rewarded-ad completion before grant.
- Pro policy can direct-grant according to policy.
- Rewarded-ad provider contracts and provider-authority lock tests pass.
- A live authorized ad provider, persistent reward history, and reward grant owner are still absent.
- Therefore the production gift action intentionally fails closed with explicit user feedback.

### Home live metrics

Status: `MISSING_LIVE_DATA_INTEGRATION`

`HomeScreen` is currently canonical artwork plus transparent interaction hotspots. Step count, active minutes, Rune Energy, hero/world summary values shown inside the artwork are not supplied as live runtime fields by `HomeScreen`.

### Daily Summary live data

Status: `MISSING_LIVE_DATA_INTEGRATION`

`DailySummaryPopup` is canonical artwork plus interaction hotspots. It has no authoritative summary-data model connected in production.

### Events

Status: `MISSING_EVENT_ENGINE`

Events/Event Detail UI and routes exist. No authoritative event-state repository/engine was found, so Join/Tasks are intentionally not allowed to fake completion.

### Messages

Status: `MISSING_FEATURE_OWNER`

No production Rune Gelen Kutusu/message screen or message engine was found.

### Settings

Status: `PARTIAL`

- Navigation/back/root interaction is connected.
- Permissions manage action reaches the platform app-settings boundary.
- Preference/account/privacy/accessibility mutations without an authoritative persistence owner fail visibly rather than silently.

## Validation gate

GitHub Actions run `36147004762` completed successfully on `1b059ec72220fb9fa430bc28d1034815eeaed647`.

Passed steps:

- Python production interaction audit
- strict Dart formatting
- `flutter analyze`
- Home subtree focused interaction + engine tests
- production interaction wiring tests
- full Flutter test suite
- diff hygiene

The Home-focused test gate explicitly includes quest engine, progression policy, Rune Shrine/rewarded-ad policy, monetization provider contracts, provider-authority lock, Rune Shrine result, route, popup, settings, permissions, and child-navigation coverage.

## Safety / truthfulness rule

This audit deliberately does not replace missing providers, repositories, persistence, live movement data, event state, message state, or economy mutation owners with fixtures or hard-coded success paths.

## Final classification

- HOME_VISIBLE_TAPS: `PASS`
- HOME_ROUTES: `PASS`
- HOME_CHILD_NAVIGATION: `PASS`
- HOME_PRODUCTION_WIRING: `PASS`
- HOME_ENGINE_POLICIES: `PASS_WHERE_IMPLEMENTED`
- HOME_LIVE_ENGINE_INTEGRATION: `PARTIAL`
- SILENT_DEAD_TAPS_IN_VALIDATED_HOME_SUBTREE: `NONE_KNOWN`
- RESULT: `PASS_WITH_EXPLICIT_EXTERNAL_BLOCKERS`
