# ActiRune visual authority transfer — 2026-09-21

This branch collects the current ActiRune visual authority and the 7 approved social/ranking references without touching `main`.

## Intended binary set

- 115 route/runtime/reference visuals from `ACTIRUNE_VISUAL_AUTHORITY_CODEX_READY_20260919.zip`
- 7 approved social/ranking visuals from `ACTIRUNE_SOCIAL_APPROVED_REFERENCES_20260921.zip`
- Total binary visuals: 122

## Target repository paths

- `visual_authority/20260921/current/<authority-category>/...`
- `visual_authority/20260921/social_approved/...`

## Social placement contract

1. Rune Ligi -> Profil -> Rune Ligi
2. Rune Dostları -> Profil -> Rune Dostları
3. Muhafız Profili -> player card from Rune Ligi / Rune Dostları
4. Rune Düellosu -> active duel / Rune Gelen Kutusu challenge notification
5. Meydan Oku popup -> Muhafız Profili / Rune Dostları
6. Rune Gelen Kutusu -> Ana Dünya -> Mesajlar
7. Tebrik Gönder popup -> Muhafız Profili / Rune Dostları

## Implementation rule

These visuals are not wallpaper-only assets. The production implementation must follow:

`3D artwork shell -> dynamic data/text -> invisible hotspot -> route/state/engine`

Every visually clickable affordance must be inventoried, bound, and emulator-tested.

## Transfer integrity

Do not substitute, redraw or regenerate images during transfer. The exact selected PNG bytes and SHA-256 values are authoritative. Binary transfer is tracked separately from this text index.
