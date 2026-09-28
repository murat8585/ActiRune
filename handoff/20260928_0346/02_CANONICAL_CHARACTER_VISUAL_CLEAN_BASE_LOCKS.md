# 02 — CANONICAL CHARACTER / VISUAL / CLEAN-BASE LOCKS

## ActiHero
- Young male
- Wavy dark-brown hair
- Navy/black armor
- Restrained gold details
- Cyan rune/crystal energy on chest
- Blue cape
- Charismatic heroic appearance
- Identity/silhouette/sex should not randomly change between screens

## Lumi
- Large adult WHITE WOLF
- Realistic/professional fantasy wolf proportions
- Cyan/ice-blue glowing eyes
- White/silver fur
- Restrained cyan rune energy
- Navy/black/gold premium harness/collar
- Cyan crystal details
- Never cat, fox, puppy, chibi, small dog or humanoid

## Visual identity
Premium mobile fantasy RPG; dark fantasy fused with restrained sci-fi rune technology.

Palette/material hierarchy:
- deep navy
- black/dark stone
- dark metal
- cyan/ice-blue rune illumination
- controlled gold accents
- magical crystal/glass
- cinematic light/shadow
- strong 3D/2.5D depth

Avoid:
- generic fantasy UI templates
- flat Material-card reinterpretation
- cheap cartoon/chibi conversion
- uncontrolled neon/cyan flood
- uncontrolled gold
- unreadable fake typography

## Screen format
- portrait 9:16
- independent full-screen asset
- highest practical quality
- 2160x3840 master preferred where generation allows
- no phone bezel/device frame
- no contact sheet/collage as final asset
- no watermark

## Clean-base application architecture
`Premium static base artwork + Flutter runtime text + runtime localization + authoritative player/game/economy state + transparent hotspots`

### Base PNG owns
- environment
- camera/composition
- permanent character art
- decorative frames
- panel/button geometry
- permanent iconography
- rune atmosphere
- empty runtime surfaces

### Flutter/runtime owns
- player name
- level / XP
- Gold / Crystal / Rune values
- item quantities
- quest progress
- HP / energy
- timer/cooldown
- progress-bar fills
- selected/equipped/current states
- ownership/entitlement
- claimed/purchased state
- event countdown
- all localizable labels/button strings

## Neutral state requirement
The static image should not imply mutable player state by using stronger UI highlight.
Examples that required corrections:
- Inventory selected category
- Achievement selected filter
- Progression middle reward chest
- Movement Mastery selected reward/card
- Lumi center appearance card
- Lumi right evolution form

Intrinsic art variation is allowed. UI selection treatment is not.

## Source isolation
When future surgical visual fixes are required:
1. use exact original approved source
2. do not use previous AI output
3. do not borrow another screen's layout/panels/character
4. preserve source geometry/composition
5. remove only mutable/localizable state
6. one source -> one output

## Localization targets discussed
- Turkish
- English
- German
- Spanish
- Portuguese
- Brazilian Portuguese
- Bahasa Indonesia
- Chinese
- Japanese
- French appeared in clean-base requirements

Runtime must handle localization; artwork should not be regenerated per language unless an explicit store-marketing asset task requires it.
