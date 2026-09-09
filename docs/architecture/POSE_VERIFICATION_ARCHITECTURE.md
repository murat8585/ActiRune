# POSE VERIFICATION ARCHITECTURE

## Production chain
Camera -> InputImageAdapter -> MlKitPoseProvider -> PoseNormalizer ->
ExerciseDetector -> RepValidator -> VerifiedRep -> CombatEngine

## Hard rules
- STREAM_MODE / continuous-video detector behavior.
- Only one inference in flight.
- Latest frame wins; do not queue stale frames.
- Rep counting is a deterministic state machine.
- Confidence + visibility + depth + minimum duration + full return.
- Landmark loss freezes progression; it never fabricates a rep.
- Threshold constants remain configuration until corpus validation.

## Validation lab before release
Create labelled videos for:
- full valid reps
- half reps
- fast/bouncy reps
- camera too close/far
- partial body occlusion
- low/high light
- different body sizes/clothing
- left/right side orientation
- knee push-up/full push-up variants where applicable

For each clip store expected rep count + failure reason.
Run offline evaluation and export golden vectors.
The Flutter detector must reproduce the golden result.

## V1 acceptance gate
- Initial target: >=19/20 valid squat detection under supported setup.
- Zero count for intentional half-reps in negative corpus.
- No double count without return to start.
- No ghost rep after landmark loss.
- One VerifiedRep -> one CombatEngine damage event.
