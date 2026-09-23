# Physical-device ML Kit evidence

This directory stores **metadata/result evidence only**, not raw personal footage.

Start from `evidence.template.json`, save the working file as `evidence.json`, and add one JSON record per labelled physical-device clip/session.

Required record fields:

- `commitSha`
- `build`
- `mlKitPackageVersion`
- `deviceModel`
- `osVersion`
- `camera`: `front` or `rear`
- `orientation`: `portrait` or `landscape`
- `lighting`
- `framing`
- `corpusId`: anonymous machine-safe subject id
- `sessionId`
- `movement`: `squat`, `lunge`, `pushUp`, `plank`
- `expectedLabel`
- `expectedInvalidNonCountLabel`
- `observedAcceptedEvents`
- `observedRejectedEvents`
- `falsePositives`
- `falseNegatives`
- `occlusionConfidenceNotes`
- `duplicateReplayNotes`
- `performanceLifecycleNotes`
- `coverage`
- `reviewerDisposition`: `pass`, `fail`, `needsThresholdReview`
- optional `mediaHash` for integrity linkage to externally managed approved media

Coverage values:

- `normalValid`
- `incompleteMovement`
- `incorrectForm`
- `speedVariation`
- `occlusionConfidenceLoss`
- `cameraFramingVariation`
- `leftRightOrientation`
- `plankHoldValidation`
- `duplicateReplay`
- `battleIntegration`
- `cameraLifecycle`

Validate with:

```text
dart run tool/validate_physical_mlkit_evidence.dart validation/physical_device_mlkit/evidence.json
```

The validator may output `READY_FOR_HUMAN_REVIEW`. That is deliberately **not** a release PASS. Final acceptance still requires human review of the real-device corpus, false-positive/false-negative behavior, supported-device scope and any threshold decision under `docs/release/PHYSICAL_DEVICE_MLKIT_VALIDATION_GATE.md`.

Forbidden repository evidence fields include raw personal video/path/bytes and real-name/biometric identity fields. Keep raw footage outside the repository under the approved privacy/storage process.
