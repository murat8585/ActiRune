# ActiRune Physical-Device ML Kit Validation Gate

Date: 2026-09-23
Status: `BLOCKED_EXTERNAL_PROOF` until real-device evidence is recorded.

## Purpose

ActiRune converts camera-observed human movement into gameplay actions. Unit tests prove deterministic detector/state-machine behavior for synthetic landmark inputs; they do **not** prove camera framing, ML Kit landmark stability, real-human form handling, device performance or false-positive resistance. This gate defines the evidence required before the movement layer can be called release-validated.

No numeric pass threshold is invented in this document. Threshold acceptance must be derived from the labelled corpus results and an explicit product/engineering decision recorded after measurement.

## Release rule

The gate is PASS only when all four Phase-1 movements have real-human labelled-corpus results on physical devices and the resulting evidence has been reviewed against the exact app commit being released:

- Squat
- Lunge
- Push-up
- Plank

Synthetic tests, emulator camera feeds, screenshots and CI logs alone cannot satisfy this gate.

## Required test record for every session

Record at minimum:

- App Git commit SHA.
- Flutter build version/build number.
- `google_mlkit_pose_detection` package version.
- Device manufacturer/model.
- Android/iOS version.
- Front/rear camera used.
- Portrait/landscape orientation actually tested.
- Lighting condition.
- Approximate camera distance/framing description.
- Test subject anonymous corpus id, not a real name.
- Clip/session id.
- Movement type.
- Labelled expected valid repetitions or expected hold interval.
- Labelled invalid-form segments.
- Expected non-count segments.
- Observed accepted events.
- Observed rejected/invalid events.
- False-positive notes.
- False-negative notes.
- Confidence-loss/occlusion behavior.
- Duplicate-event/replay behavior.
- Crash, freeze, camera lifecycle and frame-processing observations.
- Reviewer result: PASS / FAIL / NEEDS_THRESHOLD_REVIEW.

Do not store unnecessary biometric identity data in the repository. Test video handling must follow the approved privacy/storage process; the repo may store corpus ids, labels, hashes and result summaries rather than raw personal footage.

## Corpus coverage

### 1. Normal valid execution

For each movement, include multiple clean examples performed at ordinary speed and form. Verify that a physically completed movement creates the intended single verified event and does not double-count.

### 2. Incomplete movement

Include partial range-of-motion attempts and abandoned repetitions. The detector must not award a complete verified event merely because the pose briefly resembles an intermediate state.

### 3. Incorrect form

Include deliberately labelled form errors relevant to the movement. Expected behavior must follow the existing detector contract: invalid/unsafe form must not be rewarded as a better result. Do not turn this into medical diagnosis.

### 4. Speed variation

Include slower and faster human execution. The purpose is to find tracking instability, missed transitions and accidental duplicate events. This document does not authorize rewarding unsafe speed.

### 5. Occlusion and landmark confidence loss

Cover temporary body-part occlusion, partial body exit from frame and unstable landmark confidence. Verify the detector behavior already encoded in regression tests, especially that hidden time/repetitions are not magically counted while observation is lost.

### 6. Camera/framing variation

Include reasonable variations in:

- subject distance,
- vertical framing,
- left/right positioning,
- background clutter,
- ordinary indoor lighting,
- brighter/dimmer conditions that remain realistically usable.

The goal is not to guarantee impossible conditions. It is to establish the usable operating envelope honestly.

### 7. Left/right orientation

Where the detector consumes side-specific joints or movement symmetry, include examples that exercise both visible sides and orientation changes. Verify that one side is not accidentally the only functional path.

### 8. Plank-specific hold validation

Include:

- continuous valid hold,
- insufficient hold duration,
- observed body-line break,
- temporary confidence loss,
- leaving/re-entering frame,
- a new valid hold after a broken attempt.

Confirm that elapsed hidden time during unobserved/confidence-loss periods is not credited contrary to the verified detector contract.

### 9. Duplicate/replay resistance

For all four movements, verify that one physical event produces at most one accepted gameplay event. Include boundary cases around state transitions and timestamp/event identity handling.

### 10. Battle-session integration

At least one physical-device scenario for each movement must traverse the real path:

`Camera -> ML Kit pose -> movement detector -> VerifiedRep -> VerifiedMovementRouter -> BattleSessionEngine -> CombatEngine`

Verify:

- live battle accepts an eligible verified movement,
- paused/non-live battle does not mutate combat,
- a duplicate verified event is not applied twice,
- `formScore` reaches the existing combat semantics without inventing new balance values.

## Device coverage policy

Before release, define an explicit supported-device matrix based on the actual target market and minimum OS policy. The matrix must include more than one physical device class where feasible, rather than declaring victory because one conveniently cooperative phone survived a demo.

This document deliberately does not invent exact device counts or model names. Those are release-management decisions and must be recorded when the target device/OS support policy is fixed.

## Evidence artifact template

Create one result row per labelled clip/session using fields equivalent to:

| Field | Value |
|---|---|
| Commit | |
| Build | |
| Device / OS | |
| Camera | |
| Corpus ID | |
| Clip/session ID | |
| Movement | |
| Expected valid events/hold | |
| Expected invalid/non-count segments | |
| Observed result | |
| False positives | |
| False negatives | |
| Occlusion/confidence notes | |
| Duplicate/replay notes | |
| Performance/lifecycle notes | |
| Reviewer disposition | PASS / FAIL / NEEDS_THRESHOLD_REVIEW |

## Threshold-change rule

If real-human evidence shows a detector threshold must change:

1. Do not tune by random trial-and-error on one clip.
2. Identify the labelled failure pattern across the corpus.
3. Propose the smallest configuration change.
4. Re-run the affected labelled corpus and detector unit/regression suite.
5. Record before/after false-positive and false-negative observations.
6. Keep the threshold configurable unless product authority explicitly locks it.
7. Run the repository Direct Validation gate after code/test changes.

## Gate completion checklist

- [ ] Squat labelled real-human corpus completed.
- [ ] Lunge labelled real-human corpus completed.
- [ ] Push-up labelled real-human corpus completed.
- [ ] Plank labelled real-human corpus completed.
- [ ] Multiple realistic framing/lighting conditions covered.
- [ ] Occlusion/confidence-loss cases covered.
- [ ] Incorrect/incomplete movement cases covered.
- [ ] Left/right orientation coverage completed where applicable.
- [ ] Duplicate/replay behavior physically exercised.
- [ ] End-to-end battle path physically exercised for all four movements.
- [ ] Camera pause/resume/lifecycle behavior checked on physical devices.
- [ ] False-positive/false-negative findings reviewed.
- [ ] Any threshold changes revalidated against the corpus and regression suite.
- [ ] Exact release commit/build recorded.
- [ ] Final reviewer disposition recorded.

Until every required item is supported by real evidence, this gate remains **BLOCKED_EXTERNAL_PROOF**, not PASS.
