import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:actirune/features/pose/provider/mlkit_pose_provider.dart';
import 'package:actirune/features/pose/provider/pose_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

void main() {
  InputImage image(int marker) => InputImage.fromBytes(
    bytes: Uint8List.fromList([marker]),
    metadata: InputImageMetadata(
      size: const Size(1, 1),
      rotation: InputImageRotation.rotation0deg,
      format: InputImageFormat.nv21,
      bytesPerRow: 1,
    ),
  );

  PoseFrame result(int marker, DateTime timestamp) => PoseFrame(
    timestamp: timestamp,
    joints: {
      Joint.leftHip: JointPoint(x: marker.toDouble(), y: 0, confidence: 1),
    },
  );

  test(
    'inference has exactly one flight and keeps only latest pending frame',
    () async {
      final gates = <int, Completer<void>>{};
      var concurrent = 0;
      var maximumConcurrent = 0;
      final processed = <int>[];
      final provider = MlKitPoseProvider(
        inference: (input, timestamp) async {
          final marker = input.bytes!.first;
          processed.add(marker);
          concurrent++;
          maximumConcurrent = concurrent > maximumConcurrent
              ? concurrent
              : maximumConcurrent;
          final gate = gates.putIfAbsent(marker, Completer<void>.new);
          await gate.future;
          concurrent--;
          return result(marker, timestamp);
        },
      );
      final emitted = <PoseFrame>[];
      provider.frames.listen(emitted.add);
      await provider.start();

      final first = provider.processInputImage(image(1));
      await Future<void>.delayed(Duration.zero);
      await provider.processInputImage(image(2));
      await provider.processInputImage(image(3));
      gates[1]!.complete();
      await Future<void>.delayed(Duration.zero);
      gates[3]!.complete();
      await first;
      await Future<void>.delayed(Duration.zero);

      expect(processed, [1, 3]);
      expect(maximumConcurrent, 1);
      expect(emitted.map((item) => item[Joint.leftHip]!.x), [1, 3]);
      await provider.stop();
    },
  );

  test('stopped provider ignores frames', () async {
    var calls = 0;
    final provider = MlKitPoseProvider(
      inference: (input, timestamp) async {
        calls++;
        return result(1, timestamp);
      },
    );
    await provider.processInputImage(image(1));
    expect(calls, 0);
  });
}
