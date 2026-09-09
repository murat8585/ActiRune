# ActiRune

This is the pre-Codex first application scaffold.

## What is already implemented
- Flutter project source layout
- 5-tab canonical app shell
- condensed first-value onboarding
- Home screen prototype
- Flame battle canvas inside Flutter
- Flutter battle HUD overlay
- deterministic CombatEngine
- prototype verified-rep debug path -> boss HP
- PoseProvider abstraction
- ML Kit provider shell with single-inference-flight rule
- squat state machine
- tests for combat invariant
- asset-production contract
- pose-validation architecture
- game-engine decision

## Important limitation of this environment
Flutter SDK is not installed in the current execution environment, so `flutter pub get`,
platform project generation, compilation, analyzer and device execution cannot be run here.
No claim is made that the project has compiled yet.

## First command on a Flutter 3.44+/Dart 3.12+ machine
From the project directory:
1. `flutter create . --platforms=android,ios`
2. Verify generated platform files before overwriting any deliberate local config.
3. `flutter pub get`
4. `flutter analyze`
5. `flutter test`

Then complete the CameraImage -> InputImage adapter and run the real-device pose gate.

## Critical
Prototype geometric battle shapes are scaffolding only. They do not replace locked ActiRune artwork.
Use docs/visual_reference and the master handoff as source-of-truth.
