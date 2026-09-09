enum Joint {
  leftShoulder, rightShoulder, leftElbow, rightElbow, leftWrist, rightWrist,
  leftHip, rightHip, leftKnee, rightKnee, leftAnkle, rightAnkle,
}

class JointPoint {
  const JointPoint({required this.x, required this.y, required this.confidence});
  final double x;
  final double y;
  final double confidence;
}

class PoseFrame {
  const PoseFrame({required this.timestamp, required this.joints});
  final DateTime timestamp;
  final Map<Joint, JointPoint> joints;
  JointPoint? operator [](Joint joint) => joints[joint];
}

abstract interface class PoseProvider {
  Stream<PoseFrame> get frames;
  Future<void> start();
  Future<void> stop();
}
