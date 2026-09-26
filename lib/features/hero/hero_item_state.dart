import 'package:flutter/foundation.dart';

enum InventoryCategory { equipment, runes, potions, materials }

enum InventoryViewMode { grid, list }

enum HeroItemRarity { common, rare, epic, legendary }

enum InventorySortMode { title, rarity, quantity }

enum EquipmentSlot {
  weapon,
  helmet,
  gloves,
  ring,
  necklace,
  chest,
  boots,
  rune,
}

@immutable
class HeroItem {
  const HeroItem({
    required this.id,
    required this.title,
    required this.category,
    required this.rarity,
    required this.quantity,
    this.compatibleSlots = const {},
  });

  final String id;
  final String title;
  final InventoryCategory category;
  final HeroItemRarity rarity;
  final int quantity;
  final Set<EquipmentSlot> compatibleSlots;

  HeroItem withQuantity(int value) => HeroItem(
    id: id,
    title: title,
    category: category,
    rarity: rarity,
    quantity: value,
    compatibleSlots: compatibleSlots,
  );
}

@immutable
class CraftingRecipeDefinition {
  const CraftingRecipeDefinition({
    required this.id,
    required this.inputQuantities,
    required this.output,
  });

  final String id;
  final Map<String, int> inputQuantities;
  final HeroItem output;
}

enum CraftResult { applied, duplicateTransaction, invalidRecipe, missingInputs }

/// A local state mechanism that starts empty in production. Only a verified
/// external owner may supply owned items or recipe definitions; the artwork is
/// never used as an item catalog or as evidence of player ownership.
class HeroItemOwner extends ChangeNotifier {
  HeroItemOwner({Iterable<HeroItem> initialOwnedItems = const []}) {
    for (final item in initialOwnedItems) {
      _validateItem(item);
      if (_items.containsKey(item.id)) {
        throw ArgumentError('Duplicate owned item ID: ${item.id}');
      }
      _items[item.id] = item;
    }
  }

  final Map<String, HeroItem> _items = {};
  final Map<EquipmentSlot, String> _equipped = {};
  final Set<String> _appliedCraftTransactions = {};

  InventoryCategory selectedCategory = InventoryCategory.equipment;
  InventoryViewMode viewMode = InventoryViewMode.grid;
  InventorySortMode sortMode = InventorySortMode.title;
  HeroItemRarity? rarityFilter;
  String searchQuery = '';
  EquipmentSlot selectedSlot = EquipmentSlot.weapon;
  String? selectedItemId;

  List<HeroItem> get ownedItems => List.unmodifiable(_items.values);
  List<HeroItem> get visibleItems {
    final matching = _items.values.where((item) {
      return item.category == selectedCategory &&
          (rarityFilter == null || item.rarity == rarityFilter) &&
          item.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
    matching.sort((a, b) {
      final result = switch (sortMode) {
        InventorySortMode.title => a.title.compareTo(b.title),
        InventorySortMode.rarity => b.rarity.index.compareTo(a.rarity.index),
        InventorySortMode.quantity => b.quantity.compareTo(a.quantity),
      };
      return result == 0 ? a.id.compareTo(b.id) : result;
    });
    return List.unmodifiable(matching);
  }

  Map<EquipmentSlot, String> get equippedItemIds => Map.unmodifiable(_equipped);
  HeroItem? get selectedItem => _items[selectedItemId];

  void selectCategory(InventoryCategory category) {
    if (selectedCategory == category) return;
    selectedCategory = category;
    selectedItemId = null;
    notifyListeners();
  }

  void selectViewMode(InventoryViewMode mode) {
    if (viewMode == mode) return;
    viewMode = mode;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (searchQuery == query.trim()) return;
    searchQuery = query.trim();
    selectedItemId = null;
    notifyListeners();
  }

  void setRarityFilter(HeroItemRarity? rarity) {
    if (rarityFilter == rarity) return;
    rarityFilter = rarity;
    selectedItemId = null;
    notifyListeners();
  }

  void setSortMode(InventorySortMode mode) {
    if (sortMode == mode) return;
    sortMode = mode;
    notifyListeners();
  }

  bool selectItem(String id) {
    if (!_items.containsKey(id)) return false;
    selectedItemId = id;
    notifyListeners();
    return true;
  }

  void selectSlot(EquipmentSlot slot) {
    if (selectedSlot == slot) return;
    selectedSlot = slot;
    notifyListeners();
  }

  List<HeroItem> compatibleOwnedItems(EquipmentSlot slot) => List.unmodifiable(
    _items.values.where((item) => item.compatibleSlots.contains(slot)),
  );

  bool equip(String itemId, EquipmentSlot slot) {
    final item = _items[itemId];
    if (item == null ||
        item.quantity < 1 ||
        !item.compatibleSlots.contains(slot) ||
        _equipped[slot] == itemId) {
      return false;
    }
    final useCount = _equipped.entries
        .where((entry) => entry.key != slot && entry.value == itemId)
        .length;
    if (useCount >= item.quantity) return false;
    _equipped[slot] = itemId;
    notifyListeners();
    return true;
  }

  bool unequip(EquipmentSlot slot) {
    if (_equipped.remove(slot) == null) return false;
    notifyListeners();
    return true;
  }

  /// Atomic in-memory fixture mechanism. Production does not call this until
  /// recipe, inventory and durable transaction authorities are integrated.
  CraftResult craft({
    required CraftingRecipeDefinition recipe,
    required String transactionId,
  }) {
    if (transactionId.trim().isEmpty ||
        recipe.id.trim().isEmpty ||
        recipe.inputQuantities.isEmpty ||
        recipe.inputQuantities.values.any((quantity) => quantity <= 0)) {
      return CraftResult.invalidRecipe;
    }
    if (_appliedCraftTransactions.contains(transactionId)) {
      return CraftResult.duplicateTransaction;
    }
    try {
      _validateItem(recipe.output);
    } on ArgumentError {
      return CraftResult.invalidRecipe;
    }
    final next = Map<String, HeroItem>.of(_items);
    for (final entry in recipe.inputQuantities.entries) {
      final owned = next[entry.key];
      final equippedCount = _equipped.values
          .where((id) => id == entry.key)
          .length;
      if (owned == null || owned.quantity - equippedCount < entry.value) {
        return CraftResult.missingInputs;
      }
      final remaining = owned.quantity - entry.value;
      if (remaining == 0) {
        next.remove(entry.key);
      } else {
        next[entry.key] = owned.withQuantity(remaining);
      }
    }
    final priorOutputIdentity = _items[recipe.output.id];
    if (priorOutputIdentity != null &&
        !_sameItemDefinition(priorOutputIdentity, recipe.output)) {
      return CraftResult.invalidRecipe;
    }
    final existing = next[recipe.output.id];
    next[recipe.output.id] = recipe.output.withQuantity(
      (existing?.quantity ?? 0) + recipe.output.quantity,
    );
    _items
      ..clear()
      ..addAll(next);
    _appliedCraftTransactions.add(transactionId);
    notifyListeners();
    return CraftResult.applied;
  }

  static void _validateItem(HeroItem item) {
    if (item.id.trim().isEmpty ||
        item.title.trim().isEmpty ||
        item.quantity <= 0) {
      throw ArgumentError(
        'Owned item identity, title and quantity are required',
      );
    }
    if (item.category == InventoryCategory.materials &&
        item.compatibleSlots.isNotEmpty) {
      throw ArgumentError('Materials cannot be equipped');
    }
  }

  static bool _sameItemDefinition(HeroItem a, HeroItem b) =>
      a.title == b.title &&
      a.category == b.category &&
      a.rarity == b.rarity &&
      setEquals(a.compatibleSlots, b.compatibleSlots);
}
