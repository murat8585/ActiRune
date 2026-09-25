import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../combat/combat_engine.dart';

class ActiRuneBattleGame extends FlameGame {
  ActiRuneBattleGame(this.combat);
  final CombatEngine combat;

  late final RectangleComponent boss;
  late final CircleComponent lumi;
  late final RectangleComponent hero;

  @override
  Color backgroundColor() => const Color(0xFF071827);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: size,
        paint: Paint()..color = const Color(0xFF0A2946),
        priority: -10,
      ),
    );

    boss = RectangleComponent(
      position: Vector2(size.x * .5, size.y * .14),
      anchor: Anchor.topCenter,
      size: Vector2(size.x * .48, size.y * .36),
      paint: Paint()..color = const Color(0xFF1A75A8),
    );
    add(boss);

    hero = RectangleComponent(
      position: Vector2(size.x * .5, size.y * .70),
      anchor: Anchor.center,
      size: Vector2(size.x * .18, size.y * .22),
      paint: Paint()..color = const Color(0xFFD5A63E),
    );
    add(hero);

    lumi = CircleComponent(
      position: Vector2(size.x * .24, size.y * .64),
      radius: size.x * .06,
      paint: Paint()..color = const Color(0xFF57D9FF),
    );
    add(lumi);
  }

  void playVerifiedHit() {
    boss.scale = Vector2.all(.96);
    Future<void>.delayed(const Duration(milliseconds: 100), () {
      if (boss.isMounted) boss.scale = Vector2.all(1);
    });
  }
}
