# ActiRune Remaining 13 Selected Visuals — 2026-09-21

## Package identity and authority status

- Source archive: `ACTIRUNE_REMAINING_13_SELECTED_FINALS_20260921.zip`
- Expected and verified ZIP SHA-256: `287c2ce96ee6a518131ee586e9cb3cf4741af02c012287ddfc9b5413dbc91d07`
- The 13 selected PNGs and the archive-provided `README.md`, `SELECTION_MANIFEST.tsv`, and `SHA256SUMS.txt` are retained in this directory. The three supplied documents were copied byte-for-byte.
- Every PNG copy matches the SHA-256 and byte length recorded for the source archive. No image was generated, edited, resized, re-encoded, or overwritten.
- `REMAINING_13_FINAL_SELECTION_MANIFEST_20260921.tsv` records the screen contract for each image. All rows use `SELECTED_FINAL_VISUAL_AUTHORITY_CANDIDATE`; transfer does not by itself implement a route, hotspot, state binding, engine behavior, or runtime correctness.
- Historical visual-authority files are untouched. This package adds files only under `visual_authority/20260921/final_remaining_13/`.

## Shared locked product rules

- Permanent root navigation is exactly: `Ana Dünya / Macera / Savaş / Kahraman / Profil`. Do not add a sixth tab.
- Where depicted, ActiHero is a young male with wavy dark-brown hair, navy/black armor, restrained gold details, a cyan rune/crystal, and a blue cloak.
- Where depicted, Lumi is a large white wolf with cyan eyes, icy rune glow, and a blue/gold harness or pendant. Never substitute kitten/cat/fox Lumi.
- Canonical economy terms are `Altın`, `Kristal`, `Rune Energy` (not currency), `XP` (not currency), and `Malzemeler`. Canonical rarity terms are `Normal`, `Nadir`, `Epik`, and `Efsanevi`—never `Destansı`.
- Never introduce `Mana`, `Rune Kristali`, `Atlas`, legacy UI/navigation, or paid random-draw/gacha language. The locked Rune Shrine reward policy also excludes Premium Kristal and Efsanevi progression as rewarded-ad prizes.
- Dates, timers, counts, scores, event/league placement, movement totals, progress, rewards, permissions, preference states, and history entries are dynamic data. Replace artwork fixture values with current app/state data when implementation is separately authorized.
- Do not cover the artwork with duplicate visible Flutter cards or menus. Any later interaction work is separate: bind the approved artwork's visible controls through transparent hotspots to the appropriate route/state/engine callbacks. No such implementation is included here.

## Selected screen contracts

### 1. Events — `01_EVENTS_FINAL.png`

- Screen: full Events screen in the Ana Dünya family; entry is `Ana Dünya → Etkinlikler`.
- Keep the supplied event-card hierarchy and clear event actions. The five-tab navigation is visible with `Ana Dünya` active.
- Event schedule/availability, countdowns, participation/progress, rewards, eligibility, and CTA state are dynamic. Opening an event card leads to its detail popup; returning closes back to Events.
- Keep Events distinct from the Home activity dashboard and Adventure route/map; do not create an Events bottom-navigation tab.

### 2. Event Detail Popup — `02_EVENT_DETAIL_POPUP_FINAL.png`

- Screen: modal/popup opened from an Events card, over the Events parent; it is not a new root destination.
- Preserve the modal hierarchy and clear task-progress/action areas. The parent context remains Events with `Ana Dünya` active; do not draw a second independent bottom bar inside the popup.
- Event identity/details, schedule, tasks, progress, rewards, eligibility, and claim/action state are dynamic. Close/back returns to the Events screen.

### 3. Daily Summary Popup — `03_DAILY_SUMMARY_POPUP_FINAL.png`

- Screen: daily summary modal opened from Ana Dünya; it is not a new root destination.
- Preserve the compact summary and movement-distribution hierarchy. The parent context is Ana Dünya with `Ana Dünya` active; do not add an independent popup navigation bar.
- Summary date, steps/activity, verified movements and distribution, active time, XP, Altın/material rewards, and completion states are dynamic. Close/back returns to Ana Dünya.

### 4. Weekly League Result Popup — `04_WEEKLY_LEAGUE_RESULT_POPUP_FINAL.png`

- Screen: weekly/season result popup belonging to `Rune Ligi` in the Profile/social family—not `Rune Düellosu`.
- Preserve the Rune Ligi background context and clean tier-transition presentation. The parent context is Rune Ligi with `Profil` active; do not add a separate popup bottom bar.
- Tier transition (including the pictured Gold III → Gold II example), points, placement, period, bracket, rewards, and claim state are dynamic. Acknowledge/close returns to Rune Ligi.

### 5. Onboarding Welcome — `05_ONBOARDING_WELCOME_FINAL.png`

- Screen: focused first-run welcome, before the permanent app shell.
- Preserve the ActiRune identity, canonical Hero/Lumi, one dominant `MACERAYA BAŞLA` CTA, and the product promise. Bottom navigation is hidden.
- Onboarding step, localization, collected goal/time choices, and CTA state are dynamic where applicable. Continue into the onboarding flow; do not present this as Home or a settings page.

### 6. Calibration Result — `06_CALIBRATION_RESULT_FINAL.png`

- Screen: focused result of first calibration, before entering the first adventure; no bottom navigation.
- Preserve the five readiness indicators, the four core movement references (Squat, Lunge, Push-up, Plank), and clear CTA hierarchy. Keep the result calm and game-like; it is not a clinical diagnosis or medical score.
- Readiness/permission signals, movement profile, personalized difficulty, recommended adventure time, first-reward teaser, and CTA state are dynamic. Continue to the first Adventure/mini encounter.

### 7. Rune Shrine Result — `07_RUNE_SHRINE_RESULT_FINAL.png`

- Screen: child result/reveal for the voluntary Rune Shrine reward; the product authority places the Rune Shrine entry on Ana Dünya.
- The supplied selection notes describe `Kahraman` as active in this image, while the Master Product Bible places the Rune Shrine entry on Ana Dünya. Preserve this selected PNG byte-for-byte and keep it a candidate; reconcile the active-tab/context decision before canonical lock or route implementation.
- Reward identity/quantity, readiness/cooldown, ad eligibility/completion, and result state are dynamic. Keep the reward voluntary/free as applicable; no paid random draw/gacha, movement skip, Premium Kristal, or Efsanevi progression reward from a rewarded ad. Use the canonical rarity word `Efsanevi` only where it truthfully labels an item; never `Destansı`.

### 8–12. Profile Settings Children — `08` through `12`

- Screens: Hesap, Bildirimler, Gizlilik, İzinler, and Erişilebilirlik, each a distinct child destination under `Profil → Ayarlar`.
- Preserve the supplied Profile-family styling and `Profil`-active five-tab navigation. Do not merge the five pages into one route or add a Settings tab.
- Account labels/status and available account actions; notification preferences and permission state; privacy/social choices and blocked entries; OS permission/integration states (including optional health integration); and accessibility control values are dynamic. Destructive account deletion must remain clearly separate from routine account actions.

### 13. Profile History — `13_PROFILE_HISTORY_FINAL.png`

- Screen: `Profil → Geçmiş`, a Profile child destination with `Profil` active in the permanent five-tab navigation.
- Preserve the timeline, history-card, tab, and filter hierarchy. History dates/entries, activity summaries, selected category/filter/tab, pagination, and empty/loading states are dynamic. Do not turn history into a sixth root tab.

## Transfer boundary

This is an artwork-and-documentation transfer only. It does not change app source, product routes, transparent hotspots, state, engine, tests, build, emulator, device, or runtime behavior. The archive-provided files remain unchanged alongside this repository-specific screen-contract README and manifest.
