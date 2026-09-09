# ACTIRUNE ASSET PRODUCTION CONTRACT

The locked concept boards are visual source-of-truth, not runtime atlases.
Codex must NOT invent replacement art.

## Runtime asset families required before production polish
1. Brand
   - app icon master
   - A-rune logo transparent
2. Hero
   - Warrior/Mage/Ranger full-body transparent key art
   - battle pose variants
   - portrait/avatar crops
3. Lumi
   - idle transparent
   - cheer/charge/victory
   - milestone evolution forms
4. Yeşil Vadi
   - home background
   - adventure map background
   - battle backgrounds
5. Enemies
   - 6–8 normal
   - 2 elite
   - 1 main boss
6. Battle animation
   - boss idle/hit/heavy-hit/stagger/attack/phase/defeat
   - hero idle/attack/heavy/guard/rune/victory
   - Lumi idle/cheer/charge/victory
7. VFX
   - cyan rune impact
   - gold critical/ultimate
   - shield
   - phase transition
   - loot glow
8. Loot/UI
   - chest
   - six equipment slot icons
   - rarity frames
   - currency icons: Gold/Rune Shard/Crystal/Rune Dust
9. Social/quest
   - achievement badges
   - challenge card decoration
   - profile frames

## Preferred V1 format
- Static: WebP/PNG with transparent alpha where required.
- Animations: sprite sequences / sprite sheets first.
- Skeletal animation only after licensing/cost decision.
- No realtime 3D model requirement in V1.

## Pixel implementation rule
Concept screenshots guide composition/hierarchy.
Final runtime assets must be exported separately and placed under assets/.
Until those files exist, code may use geometric placeholders only in prototype mode.
Geometric placeholders are NEVER final visual design.
