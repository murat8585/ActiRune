# GAME ENGINE DECISION

## Final V1 architecture
**Flutter app shell + Flame 2D/2.5D battle layer + Flutter overlays.**

### Flutter owns
Onboarding, navigation, Home, Adventure, Hero/Lumi, Quests, Social, Shop,
permissions, auth, health integrations, backend UI, settings.

### Flame owns
Battle world rendering, hero/boss/Lumi components, hit reactions, particles,
phase transitions and short combat animation.

### Flutter overlay owns during battle
Camera inset, boss HP, objective count, combo/form feedback, pause/rest,
permission/error dialogs.

## Not chosen for V1
- Unity: unnecessary second application runtime/toolchain for the current screen design.
- Godot: same integration overhead.
- Flame 3D: do not make experimental 3D infrastructure a production dependency.
- Full realtime 3D: raises asset/animation/performance complexity without improving the locked UI enough.

## Rendering target
Premium 2.5D illusion: layered cinematic backgrounds + animated transparent
hero/boss/Lumi + particles + Flutter HUD.
