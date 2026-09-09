import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

const _orientationDegrees = <DeviceOrientation, int>{
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

/// Converts the single-plane formats requested from the camera plugin into the
/// exact metadata accepted by google_mlkit_commons.
class CameraInputAdapter {
  const CameraInputAdapter();

  InputImage? convert({
    required CameraImage image,
    required CameraDescription camera,
    required DeviceOrientation deviceOrientation,
  }) {
    final isAndroid = Platform.isAndroid;
    final isIOS = Platform.isIOS;
    if (!isAndroid && !isIOS) return null;

    InputImageRotation? rotation;
    if (isIOS) {
      rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    } else {
      var compensation = _orientationDegrees[deviceOrientation];
      if (compensation == null) return null;
      compensation = camera.lensDirection == CameraLensDirection.front
          ? (camera.sensorOrientation + compensation) % 360
          : (camera.sensorOrientation - compensation + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(compensation);
    }

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    final supported = isAndroid
        ? format == InputImageFormat.nv21
        : format == InputImageFormat.bgra8888;
    if (rotation == null || !supported || image.planes.length != 1) return null;
    final plane = image.planes.single;
    if (image.width <= 0 || image.height <= 0 || plane.bytes.isEmpty) {
      return null;
    }

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format!,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
