import '../models/shopping_list_item_model.dart';

/// Contract for the shopping-list local data source.
abstract interface class ShoppingListLocalDataSource {
  List<ShoppingListItemModel> getAll();
  void add(ShoppingListItemModel model);
  void removeById(String id);
  void removeByRecipeId(String recipeId);
  void toggle(String id);
  void clearChecked();
  void clearAll();
  bool exists(String ingredientId, String recipeId);
}

/// In-memory implementation.
class ShoppingListLocalDataSourceImpl implements ShoppingListLocalDataSource {
  final List<ShoppingListItemModel> _store = [];

  @override
  List<ShoppingListItemModel> getAll() => List.unmodifiable(_store);

  @override
  void add(ShoppingListItemModel model) => _store.add(model);

  @override
  void removeById(String id) => _store.removeWhere((i) => i.id == id);

  @override
  void removeByRecipeId(String recipeId) =>
      _store.removeWhere((i) => i.recipeId == recipeId);

  @override
  void toggle(String id) {
    final index = _store.indexWhere((i) => i.id == id);
    if (index != -1) {
      _store[index] = _store[index].copyWith(isChecked: !_store[index].isChecked);
    }
  }

  @override
  void clearChecked() => _store.removeWhere((i) => i.isChecked);

  @override
  void clearAll() => _store.clear();

  @override
  bool exists(String ingredientId, String recipeId) =>
      _store.any((i) => i.ingredientId == ingredientId && i.recipeId == recipeId);
}
