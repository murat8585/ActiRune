import 'package:flutter/foundation.dart';

enum MaterialFamily {
  runeFragment,
  ancientOre,
  monsterEssence,
  spiritDust,
  lumiEssence,
  bossCore,
}

enum LootSource { region, boss, quest, chest }

enum CraftingDecisionReason { craftable, invalidPlan, missingMaterials }

@immutable
class CraftingPlan {
  const CraftingPlan({required this.recipeId, required this.materialCosts});

  final String recipeId;
  final Map<MaterialFamily, int> materialCosts;
}

@immutable
class CraftingDecision {
  const CraftingDecision._({
    required this.allowed,
    required this.reason,
    required this.missingMaterials,
  });

  factory CraftingDecision.craftable() {
    return const CraftingDecision._(
      allowed: true,
      reason: CraftingDecisionReason.craftable,
      missingMaterials: <MaterialFamily, int>{},
    );
  }

  factory CraftingDecision.invalidPlan() {
    return const CraftingDecision._(
      allowed: false,
      reason: CraftingDecisionReason.invalidPlan,
      missingMaterials: <MaterialFamily, int>{},
    );
  }

  factory CraftingDecision.missing(Map<MaterialFamily, int> missingMaterials) {
    return CraftingDecision._(
      allowed: false,
      reason: CraftingDecisionReason.missingMaterials,
      missingMaterials: Map<MaterialFamily, int>.unmodifiable(missingMaterials),
    );
  }

  final bool allowed;
  final CraftingDecisionReason reason;
  final Map<MaterialFamily, int> missingMaterials;
}

/// Pure ownership boundary for the locked loot/crafting product rules.
///
/// Recipe ids, material quantities, drop rates, persistence, inventory mutation
/// and reward application remain caller-owned. This policy only validates a
/// caller-supplied authoritative recipe against a caller-supplied inventory.
class LootCraftingPolicy {
  const LootCraftingPolicy();

  CraftingDecision evaluateCraft({
    required CraftingPlan plan,
    required Map<MaterialFamily, int> inventory,
  }) {
    if (plan.recipeId.trim().isEmpty ||
        plan.materialCosts.isEmpty ||
        plan.materialCosts.values.any((quantity) => quantity <= 0) ||
        inventory.values.any((quantity) => quantity < 0)) {
      return CraftingDecision.invalidPlan();
    }

    final missing = <MaterialFamily, int>{};
    for (final entry in plan.materialCosts.entries) {
      final owned = inventory[entry.key] ?? 0;
      if (owned < entry.value) {
        missing[entry.key] = entry.value - owned;
      }
    }

    if (missing.isNotEmpty) {
      return CraftingDecision.missing(missing);
    }
    return CraftingDecision.craftable();
  }

  bool isAuthoritativeLootSource(LootSource source) {
    return switch (source) {
      LootSource.region ||
      LootSource.boss ||
      LootSource.quest ||
      LootSource.chest => true,
    };
  }
}
