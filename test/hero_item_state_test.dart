import 'package:flutter_test/flutter_test.dart';
import 'package:actirune/features/hero/hero_item_state.dart';

void main() {
  const sword = HeroItem(
    id: 'owned-sword',
    title: 'Test Sword',
    category: InventoryCategory.equipment,
    rarity: HeroItemRarity.rare,
    quantity: 1,
    compatibleSlots: {EquipmentSlot.weapon},
  );
  const ore = HeroItem(
    id: 'owned-ore',
    title: 'Test Ore',
    category: InventoryCategory.materials,
    rarity: HeroItemRarity.common,
    quantity: 3,
  );
  const output = HeroItem(
    id: 'crafted-blade',
    title: 'Test Blade',
    category: InventoryCategory.equipment,
    rarity: HeroItemRarity.epic,
    quantity: 1,
    compatibleSlots: {EquipmentSlot.weapon},
  );
  const recipe = CraftingRecipeDefinition(
    id: 'test-recipe',
    inputQuantities: {'owned-ore': 2},
    output: output,
  );

  test('production state is empty and only known IDs can be selected', () {
    final owner = HeroItemOwner();
    expect(owner.ownedItems, isEmpty);
    expect(owner.selectItem('artwork-sample'), isFalse);
    expect(owner.equip('artwork-sample', EquipmentSlot.weapon), isFalse);
    owner.dispose();
  });

  test('category, selection and quantity retain owned identity', () {
    final owner = HeroItemOwner(initialOwnedItems: [sword, ore]);
    expect(owner.visibleItems.map((item) => item.id), ['owned-sword']);
    expect(owner.selectItem('owned-sword'), isTrue);
    expect(owner.selectedItem?.quantity, 1);
    owner.selectCategory(InventoryCategory.materials);
    expect(owner.visibleItems.map((item) => item.id), ['owned-ore']);
    expect(owner.selectedItem, isNull);
    owner.selectViewMode(InventoryViewMode.list);
    expect(owner.viewMode, InventoryViewMode.list);
    owner.dispose();
  });

  test('search, rarity filter and quantity sort filter actual owned IDs', () {
    final owner = HeroItemOwner(
      initialOwnedItems: [
        sword,
        const HeroItem(
          id: 'other-sword',
          title: 'Another Sword',
          category: InventoryCategory.equipment,
          rarity: HeroItemRarity.common,
          quantity: 4,
        ),
      ],
    );
    owner.setSearchQuery('sword');
    expect(owner.visibleItems.map((item) => item.id), [
      'other-sword',
      'owned-sword',
    ]);
    owner.setSortMode(InventorySortMode.quantity);
    expect(owner.visibleItems.first.id, 'other-sword');
    owner.setRarityFilter(HeroItemRarity.rare);
    expect(owner.visibleItems.map((item) => item.id), ['owned-sword']);
    owner.setSearchQuery('no match');
    expect(owner.visibleItems, isEmpty);
    owner.setRarityFilter(null);
    owner.dispose();
  });

  test('equip validates ownership, compatibility and preserves inventory', () {
    final owner = HeroItemOwner(initialOwnedItems: [sword]);
    expect(owner.equip('missing', EquipmentSlot.weapon), isFalse);
    expect(owner.equip(sword.id, EquipmentSlot.helmet), isFalse);
    expect(owner.equip(sword.id, EquipmentSlot.weapon), isTrue);
    expect(owner.equip(sword.id, EquipmentSlot.weapon), isFalse);
    expect(owner.equippedItemIds[EquipmentSlot.weapon], sword.id);
    expect(owner.ownedItems.single.id, sword.id);
    expect(owner.unequip(EquipmentSlot.weapon), isTrue);
    expect(owner.unequip(EquipmentSlot.weapon), isFalse);
    expect(owner.ownedItems.single.id, sword.id);
    owner.dispose();
  });

  test('craft consumes exact inputs and rejects duplicate transaction', () {
    final owner = HeroItemOwner(initialOwnedItems: [ore]);
    expect(
      owner.craft(recipe: recipe, transactionId: 'tx-1'),
      CraftResult.applied,
    );
    expect(
      owner.ownedItems.singleWhere((item) => item.id == ore.id).quantity,
      1,
    );
    expect(
      owner.ownedItems.singleWhere((item) => item.id == output.id).quantity,
      1,
    );
    expect(
      owner.craft(recipe: recipe, transactionId: 'tx-1'),
      CraftResult.duplicateTransaction,
    );
    expect(
      owner.ownedItems.singleWhere((item) => item.id == output.id).quantity,
      1,
    );
    owner.dispose();
  });

  test('missing inputs and conflicting output roll back completely', () {
    final owner = HeroItemOwner(initialOwnedItems: [ore, sword]);
    final before = owner.ownedItems
        .map((item) => '${item.id}:${item.quantity}')
        .toList();
    expect(
      owner.craft(
        recipe: const CraftingRecipeDefinition(
          id: 'too-expensive',
          inputQuantities: {'owned-ore': 4},
          output: output,
        ),
        transactionId: 'tx-missing',
      ),
      CraftResult.missingInputs,
    );
    expect(
      owner.craft(
        recipe: const CraftingRecipeDefinition(
          id: 'conflict',
          inputQuantities: {'owned-ore': 1},
          output: HeroItem(
            id: 'owned-sword',
            title: 'Different Item',
            category: InventoryCategory.equipment,
            rarity: HeroItemRarity.rare,
            quantity: 1,
          ),
        ),
        transactionId: 'tx-conflict',
      ),
      CraftResult.invalidRecipe,
    );
    expect(
      owner.craft(
        recipe: const CraftingRecipeDefinition(
          id: 'consume-and-relabel',
          inputQuantities: {'owned-ore': 3},
          output: HeroItem(
            id: 'owned-ore',
            title: 'Relabeled Ore',
            category: InventoryCategory.materials,
            rarity: HeroItemRarity.common,
            quantity: 1,
          ),
        ),
        transactionId: 'tx-relabel',
      ),
      CraftResult.invalidRecipe,
    );
    expect(
      owner.ownedItems.map((item) => '${item.id}:${item.quantity}'),
      before,
    );
    owner.dispose();
  });

  test('equipped quantity cannot be consumed by a recipe', () {
    final owner = HeroItemOwner(initialOwnedItems: [sword]);
    expect(owner.equip(sword.id, EquipmentSlot.weapon), isTrue);
    expect(
      owner.craft(
        recipe: const CraftingRecipeDefinition(
          id: 'recycle',
          inputQuantities: {'owned-sword': 1},
          output: output,
        ),
        transactionId: 'tx-recycle',
      ),
      CraftResult.missingInputs,
    );
    expect(owner.ownedItems.single.id, sword.id);
    owner.dispose();
  });
}
