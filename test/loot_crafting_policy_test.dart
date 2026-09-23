import 'package:actirune/features/economy/loot_crafting_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = LootCraftingPolicy();

  test('locked material families remain the six authoritative families', () {
    expect(MaterialFamily.values, [
      MaterialFamily.runeFragment,
      MaterialFamily.ancientOre,
      MaterialFamily.monsterEssence,
      MaterialFamily.spiritDust,
      MaterialFamily.lumiEssence,
      MaterialFamily.bossCore,
    ]);
  });

  test('locked loot sources remain region boss quest and chest', () {
    expect(LootSource.values, [
      LootSource.region,
      LootSource.boss,
      LootSource.quest,
      LootSource.chest,
    ]);
    for (final source in LootSource.values) {
      expect(policy.isAuthoritativeLootSource(source), isTrue);
    }
  });

  test('caller-owned recipe is craftable when inventory is sufficient', () {
    const plan = CraftingPlan(
      recipeId: 'authoritative-recipe-1',
      materialCosts: {
        MaterialFamily.runeFragment: 2,
        MaterialFamily.ancientOre: 1,
      },
    );
    final inventory = <MaterialFamily, int>{
      MaterialFamily.runeFragment: 3,
      MaterialFamily.ancientOre: 1,
      MaterialFamily.bossCore: 4,
    };

    final decision = policy.evaluateCraft(plan: plan, inventory: inventory);

    expect(decision.allowed, isTrue);
    expect(decision.reason, CraftingDecisionReason.craftable);
    expect(decision.missingMaterials, isEmpty);
    expect(inventory[MaterialFamily.runeFragment], 3);
    expect(inventory[MaterialFamily.ancientOre], 1);
  });

  test('missing materials are reported without mutating inventory', () {
    const plan = CraftingPlan(
      recipeId: 'authoritative-recipe-2',
      materialCosts: {
        MaterialFamily.monsterEssence: 4,
        MaterialFamily.spiritDust: 2,
      },
    );
    final inventory = <MaterialFamily, int>{
      MaterialFamily.monsterEssence: 1,
      MaterialFamily.spiritDust: 2,
    };

    final decision = policy.evaluateCraft(plan: plan, inventory: inventory);

    expect(decision.allowed, isFalse);
    expect(decision.reason, CraftingDecisionReason.missingMaterials);
    expect(decision.missingMaterials, {MaterialFamily.monsterEssence: 3});
    expect(inventory, {
      MaterialFamily.monsterEssence: 1,
      MaterialFamily.spiritDust: 2,
    });
  });

  test('empty id non-positive costs and negative inventory are rejected', () {
    expect(
      policy
          .evaluateCraft(
            plan: const CraftingPlan(
              recipeId: '',
              materialCosts: {MaterialFamily.runeFragment: 1},
            ),
            inventory: const {},
          )
          .reason,
      CraftingDecisionReason.invalidPlan,
    );

    expect(
      policy
          .evaluateCraft(
            plan: const CraftingPlan(
              recipeId: 'bad-cost',
              materialCosts: {MaterialFamily.runeFragment: 0},
            ),
            inventory: const {},
          )
          .reason,
      CraftingDecisionReason.invalidPlan,
    );

    expect(
      policy
          .evaluateCraft(
            plan: const CraftingPlan(
              recipeId: 'negative-inventory',
              materialCosts: {MaterialFamily.runeFragment: 1},
            ),
            inventory: const {MaterialFamily.runeFragment: -1},
          )
          .reason,
      CraftingDecisionReason.invalidPlan,
    );
  });

  test('policy does not invent a recipe when material costs are absent', () {
    final decision = policy.evaluateCraft(
      plan: const CraftingPlan(
        recipeId: 'missing-authority',
        materialCosts: {},
      ),
      inventory: const {},
    );

    expect(decision.allowed, isFalse);
    expect(decision.reason, CraftingDecisionReason.invalidPlan);
  });
}
