import 'dart:math' as math;
import '../provider/pose_models.dart';

double jointAngle(JointPoint a, JointPoint b, JointPoint c) {
  final abx = a.x - b.x, aby = a.y - b.y;
  final cbx = c.x - b.x, cby = c.y - b.y;
  final dot = abx * cbx + aby * cby;
  final mag = math.sqrt(abx * abx + aby * aby) * math.sqrt(cbx * cbx + cby * cby);
  if (mag == 0) return 0;
  return math.acos((dot / mag).clamp(-1.0, 1.0)) * 180 / math.pi;
}
