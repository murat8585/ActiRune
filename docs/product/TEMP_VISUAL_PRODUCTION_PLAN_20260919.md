# ACTIRUNE TEMPORARY VISUAL PRODUCTION PLAN

**Status:** TEMPORARY OPERATIONAL PLAN  
**Created:** 2026-09-19  
**Delete when:** Phase-1 visual production is finished, each selected canonical screen is recorded in the permanent product/visual authority, and the temporary backlog is no longer needed.

> This file does **not** override `ACTIRUNE_MASTER_PRODUCT_BIBLE_20260919.md`. It is the temporary production queue that translates the locked product law into a screen-by-screen image-generation workflow.

## 0. Production law

For every screen in this file:

1. Read `ACTIRUNE_PRODUCT_AUTHORITY.md` and the Master Product Bible before generating.
2. Check the already locked canonical screens so the new screen belongs to the same visual family and does not repeat another screen's job.
3. Produce **10 separate professional portrait variants** for the current screen only.
4. Keep ActiRune's premium dark fantasy / sci-fi 3D-2.5D visual identity: deep navy/black, electric cyan/blue rune glow, restrained gold trim, cinematic fantasy environments, consistent Hero and Lumi, portrait 9:16/full-bleed composition.
5. Each screen has one primary job. Do not turn it into a generic fitness dashboard or duplicate information that already belongs to Home/Adventure/Profile.
6. The 10 variants may explore composition, framing, hierarchy and cinematic emphasis, but must not change the locked product function.
7. User selects exactly one preferred variant. That selected image becomes the canonical visual reference for that screen.
8. Record the chosen variant in permanent visual/product authority before moving to the next screen.
9. Only after the selection is locked do we continue to the next numbered screen.
10. Codex/runtime implementation follows the selected visual; Codex must not invent replacement art when an approved reference exists.

### Batch naming

Use a stable naming pattern while generating/reviewing:

`V2_P1_<NN>_<SCREEN_NAME>_V01` ... `V10`

Example: `V2_P1_01_BATTLE_PREP_V01` ... `V10`.

### Locked screens that are NOT to be regenerated

These remain visual anchors and quality references:

- Ana Dünya / Home
- Macera / Adventure
- Hareket-Kamera Hazırlık / Movement-Camera Prep
- Cinematic Live Battle
- Form Coach overlay

Small functional additions to these screens must preserve their selected composition unless the user explicitly unlocks them.

---

# PHASE-1 PRODUCTION QUEUE — 24 DESIGN JOBS

## 01. Savaşa Hazırlık / Battle Prep
**Status:** FIRST / IN PRODUCTION  
**Question answered:** “Bu düşmanı yenmek için ne yapacağım?”

### Must contain
- Cinematic Hero/Lumi vs enemy confrontation as the visual focus.
- Enemy name + level/threat.
- Encounter-prescribed movement: dynamic Squat / Lunge / Push-up / Plank, never hard-coded to Squat.
- Target reps or hold time.
- Estimated duration.
- Possible rewards: XP, Gold, regional material, rare-drop hint.
- One dominant CTA: `SAVAŞA BAŞLA`.
- Main 5-tab navigation may remain visible because active camera combat has not started yet.

### Must avoid
- Home's daily steps/activity dashboard.
- Adventure's full route/map.
- Long lore blocks.
- Too many fitness-stat cards.
- Generic flat Material UI.

### Visual objective
The screen should feel like the cinematic doorway into combat. It must approach the quality and intensity of the locked Live Battle screen without becoming the Live Battle screen itself.

---

## 02. Zafer / Victory
**Question answered:** “Bu savaştan ne kazandım ve ne ilerledi?”

### Must contain
- Strong `ZAFER` moment with Hero + Lumi + defeated enemy.
- Primary loot reveal: XP, Gold, materials, rare drop if present.
- Compact progression summary: Player XP, Hero XP, relevant Movement Mastery, Lumi Bond, World Progression.
- Level-up state can trigger a dramatic secondary overlay (`14 → 15`).
- CTA: `MACERAYA DÖN`.

### Must avoid
- Ten equally large reward cards.
- Turning result into an accounting spreadsheet.
- Showing rewards that were only possible rather than actually earned.

---

## 03. Yenilgi / Son Bir Şans
**Question answered:** “Ne oldu ve şimdi ne yapabilirim?”

### Must contain
- Respectful defeat state, not punishment/shaming.
- Short performance summary: verified movement, best combo, form, boss HP remaining.
- `TEKRAR DENE` and `MACERAYA DÖN`.
- PvE only: `SON BİR ŞANS` rewarded-ad continue, max once per battle, approximately 25–30% HP/checkpoint resume.
- Ranked/competitive variants never show ad revive.

### Must avoid
- Guilt/FOMO copy.
- Forced ad.
- Fake countdown pressure.

---

## 04. Görevler — Bugün / Daily Quests
**Question answered:** “Bugün neyi tamamlamalıyım?”

### Must contain
- Strong top progress: e.g. `GÜNLÜK MACERA 2/3` and `1 görev daha → Rün Sandığı`.
- Five daily quest candidates.
- Progress bars/states for each.
- Main milestone at 3 completed.
- Optional 5/5 Master Completion bonus.
- Quest families can include exploration, battle, form/mastery, Lumi/development and recovery.
- Clear completed/claimable states with short Lumi reaction/reward feedback.

### Must avoid
- Making 5/5 mandatory.
- Copying Home activity numbers as the main content.
- Thirty simultaneous tasks.

---

## 05. Görevler — Haftalık / Weekly Quests
**Question answered:** “Bu hafta hangi daha büyük hedeflerin peşindeyim?”

### Must contain
- Player-Level-dependent quest count:
  - Lv 1–9: 6 total / 4 main reward
  - Lv 10–24: 8 / 5
  - Lv 25–49: 10 / 6
  - Lv 50+: 12 / 7
- A visible milestone reward road (small reward → material chest → Epic Weekly Chest → advanced reward → optional 100% mastery bonus).
- Weekly goals emphasize consistency and variety, not daily ×7 repetition.
- Multiple-day activity, different movement types, boss, form, quest chain and social/raid objectives as level unlocks.

### Must avoid
- Requiring every weekly task for the main reward.
- Unsafe raw-volume competitions.

---

## 06. Macera Görevi / Quest Chain
**Question answered:** “Bu hikâye görev zincirinde neredeyim?”

### Must contain
- Multi-step fantasy chain, e.g. `Kurt Avcısı I → II → III → IV → Alfa Kurt`.
- Current step highlighted; completed steps marked; future boss teased.
- Story reward: regional item, title/cosmetic, Lumi Bond, XP/material.
- Region identity and enemy art.

### Must avoid
- A plain checklist with no narrative progression.

---

## 07. Kahraman / Hero Main
**Question answered:** “Hareketlerim Hero'yu nasıl geliştirdi?”

### Must contain
- Large premium Hero render.
- Hero Level + XP bar.
- Weapon / Armor / Rune-Talisman slots.
- Core combat stats kept compact.
- Quick entries to Loadout, Inventory and Crafting.
- Hero-specific progression, not Player Level as the dominant number.

### Must avoid
- Profile statistics overload.
- Store-first presentation.

---

## 08. Equipment / Loadout
**Question answered:** “Savaşa hangi ekipman ve desteklerle giriyorum?”

### Must contain
- Weapon, Armor, Rune/Talisman.
- 3 active item/potion slots.
- Before/after stat comparison when changing an item.
- Passive ability or combat modifier explanation.
- Clear PvP normalization note where relevant.

### Product rule
Gear supports verified movement; it never replaces movement and must never create pay-to-win dominance.

---

## 09. Envanter / Inventory
**Question answered:** “Neye sahibim ve ne işe yarıyor?”

### Must contain
- Categories: Equipment, Rune, Potions, Materials, Cosmetics.
- Rarity language: Common/Normal, Rare, Epic, Legendary.
- Quantity and use-case clarity.
- Search/filter/sort only if visually clean.

### Must avoid
Inventory sludge, dozens of meaningless currencies or hundreds of disposable junk items.

---

## 10. Crafting
**Question answered:** “Topladığım malzemelerle ne üretebilirim?”

### Must contain
- Recipe hero card/image.
- Required materials + owned/needed values.
- Gold cost.
- Resulting item and upgrade benefit.
- `ÜRET` CTA.
- Missing material tap should explain where it drops (region/boss/chest).

### Visual objective
Crafting should feel like fantasy rune-forging, not a database form.

---

## 11. Lumi
**Question answered:** “Lumi benimle nasıl büyüdü ve savaşta ne yapıyor?”

### Must contain
- Large Lumi render.
- Lumi Bond/Level.
- Evolution path.
- Heal / Shield / Assist / Ultimate role previews.
- Next evolution requirement.
- Cosmetic/customization entry.

### Product rule
Lumi is a retention/emotional-bond system, not a decorative mascot only.

---

## 12. Movement Mastery
**Question answered:** “Gerçek hareketlerde ne kadar ustalaştım?”

### Must contain
- Four clear mastery runes/cards:
  - Squat Mastery
  - Lunge Mastery
  - Push-up Mastery
  - Plank Mastery
- Current level / mastery XP.
- Form quality or verified movement count kept secondary.
- Unlock preview: title, cosmetic, visual effect or small mechanic.

### Product rule
Mastery is earned only through verified real movement and cannot be purchased.

---

## 13. Profil / Profile
**Question answered:** “ActiRune'da ben ne kadar ilerledim?”

### Must contain
- Player avatar/name/title.
- Player Level as dominant account progression.
- Selected achievements/badges.
- Short Movement Mastery summary.
- World completion summary.
- Social identity / friends entry.
- History and Settings entry.

### Must avoid
Duplicating Hero's combat equipment or Home's daily activity panel.

---

## 14. Player Level / Milestones
**Question answered:** “Bir sonraki seviyede ne açılıyor?”

### Must contain
- Player Level + XP bar.
- Next-level reward.
- Near-future milestone unlocks.
- Examples: new region, raid access, crafting tier, loadout, Ghost Duel, special cosmetic.

### Product rule
Higher level must unlock new systems/variety, not merely inflate step/repetition targets.

---

## 15. Achievements / Rozetler
**Question answered:** “Uzun vadede neleri başardım?”

### Must contain
- Achievement families: Exploration, Battle, Movement, Form, Lumi, Social, Hidden.
- Locked/unlocked progression.
- 3 favorite badges that can be displayed on Profile.
- Examples: 100 km, 1,000 verified movements, 50 bosses, region 100%, high-form milestones.

---

## 16. Pro / Paywall
**Question answered:** “Neden Pro için para ödeyeyim?”

### Must contain exactly four dominant value pillars
1. `KİŞİSEL GÜNLÜK MACERA`
2. `PRO FORM KOÇU`
3. `TÜM DÜNYALAR & BOSS'LAR`
4. `HERO & LUMI PROGRESSION+`

Secondary benefits: ad-free, long-term analytics, premium season stories/challenges, more loadouts, advanced crafting/customization.

### Must avoid
- Selling Pro primarily as “remove ads”.
- Paywalling core movement verification or basic safety/accessibility alternatives.
- Pay-to-win language.

---

## 17. Kişisel Günlük Macera / Personal Daily Adventure
**Question answered:** “Bugün benim için en doğru ActiRune macerası ne?”

### Must contain
- Estimated total time.
- Personalized walking/exploration target.
- Encounter count.
- Selected movement mix.
- Recovery-aware or difficulty-aware note.
- Final reward/boss goal.

### Engine inputs
Player Level + last 7/28 days + completion history + form + difficult movements + available time + goals + recovery state.

---

## 18. Pro Form Koçu / Long-Term Form Analytics
**Question answered:** “Formum zaman içinde nasıl gelişiyor?”

### Must contain
- Movement selector (Squat/Lunge/Push-up/Plank).
- 7/30-day trend.
- Major form dimensions appropriate to the movement.
- Positive improvement callouts and actionable next focus.
- No medical diagnosis.

### Product rule
Basic real-time form feedback remains Free; this screen is Pro's long-term analysis layer.

---

## 19. Onboarding / Welcome
**Question answered:** “ActiRune nedir ve neden devam etmeliyim?”

### Must contain
- ActiRune logo, Hero, Lumi and fantasy world.
- `Gerçekte hareket et. ActiRune'da güçlen.`
- WALK = EXPLORE / WORKOUT = FIGHT / CONSISTENCY = GROW.
- Main CTA: `MACERAYA BAŞLA`.
- The onboarding sequence that follows collects goal, available time and movement suitability without becoming a clinical form.

---

## 20. İlk Kalibrasyon / First Calibration
**Question answered:** “Sistem beni güvenli ve doğru biçimde tanıyor mu?”

### Must contain
- Live camera + pose skeleton.
- Short guided calibration steps using the four core movements or safe variants.
- Camera/full-body/light/space feedback.
- Lumi coaching.
- Calm, game-like progress rather than exam pressure.

### Output
Initial personalized difficulty and movement profile; no medical diagnosis.

---

## 21. Kalibrasyon Sonucu / First Adventure Result
**Question answered:** “Başlangıç yolum ne ve şimdi ne yapacağım?”

### Must contain
- `MACERAYA HAZIRSIN` result.
- Starting adventure/difficulty profile expressed in game language.
- Recommended daily adventure time.
- First reward/XP teaser.
- CTA to the first mini encounter/tutorial battle.

### Must avoid
A clinical fitness score as the hero message.

---

## 22. World Progression Detail
**Question answered:** “Bu bölgeyi %100 tamamlamak için ne kaldı?”

### Must contain
- Region name + `% complete`.
- Exploration nodes.
- Hidden chests.
- Region quests.
- Mini bosses / main boss.
- Special challenge.
- Region materials and 100% completion reward.

### Product rule
This screen extends Adventure; it does not repeat Home's daily stats.

---

## 23. Rune Shrine / Rewarded Ad Popup
**Question answered:** “Bu gönüllü ödülden ne kazanabilirim?”

### Must contain
- Rune Shrine fantasy object/portal/chest art.
- `Ücretsiz Rün Hediyesi` when ready.
- Possible reward pool: Gold, normal material, potion, Rune shard, low-chance cosmetic.
- Clear voluntary CTA.
- Cooldown/readiness state.

### Product law
Initial rule: once per 4 hours, max 3/day. No premium crystals, legendary progression or movement skipping. Pro gets the basic equivalent without watching the ad.

---

## 24. Mağaza / Shop Revision
**Question answered:** “Neyi isteğe bağlı olarak satın alabilir/özelleştirebilirim?”

### Must contain
- Hero cosmetics.
- Lumi cosmetics.
- Animations/effects.
- Cosmetic Rune themes.
- Crystal packs if retained.
- Pro entry can exist but should not dominate every store card.

### Must avoid
- Boss skip.
- Movement skip.
- Purchasable Movement Mastery.
- Competitive pay-to-win gear.

---

# PHASE-2+ SOCIAL QUEUE — DO NOT START UNTIL PHASE-1 IS VISUALLY CLOSED

After the 24 Phase-1 jobs are individually selected and locked:

25. Arkadaş / Sosyal Merkez
26. 2P Live Boss Raid Lobby
27. 2P Live Boss Raid
28. Raid Result
29. Ghost Duel
30. Friend Live 1v1
31. 4P Raid
32. Global Ranked Arena
33. World Boss / Guild Wars

For each of these, use the same 10-variant → user selection → canonical lock workflow.

---

# CURRENT TRACKING STATE

- [x] Home canonical screen locked — do not regenerate.
- [x] Adventure canonical screen locked — do not regenerate.
- [x] Movement/Camera Prep canonical screen locked — do not regenerate.
- [x] Live Battle canonical direction locked — do not regenerate.
- [x] Form Coach overlay locked — do not regenerate.
- [ ] 01 Battle Prep — **CURRENT**
- [ ] 02 Victory
- [ ] 03 Defeat / Last Chance
- [ ] 04 Daily Quests
- [ ] 05 Weekly Quests
- [ ] 06 Quest Chain
- [ ] 07 Hero
- [ ] 08 Equipment / Loadout
- [ ] 09 Inventory
- [ ] 10 Crafting
- [ ] 11 Lumi
- [ ] 12 Movement Mastery
- [ ] 13 Profile
- [ ] 14 Player Level / Milestones
- [ ] 15 Achievements
- [ ] 16 Pro / Paywall
- [ ] 17 Personal Daily Adventure
- [ ] 18 Pro Form Coach
- [ ] 19 Onboarding / Welcome
- [ ] 20 First Calibration
- [ ] 21 Calibration Result / First Adventure
- [ ] 22 World Progression Detail
- [ ] 23 Rune Shrine Popup
- [ ] 24 Shop Revision

## Temporary-file cleanup rule
When all Phase-1 screen selections are locked and transferred into permanent canonical visual documentation, delete this file from the repository. The permanent Product Bible and selected visual references remain.