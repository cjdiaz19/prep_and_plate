import '../entities/ingredient.dart';
import '../entities/shopping_list_item.dart';

/// Contract for all shopping-list persistence operations.
abstract interface class ShoppingListRepository {
  /// Returns all items currently on the list.
  List<ShoppingListItem> getAll();

  /// Adds [ingredient] to the list, tagged with [recipeId] / [recipeName].
  /// Silently ignores duplicates (same ingredientId + recipeId).
  void addIngredient(
      Ingredient ingredient, String recipeId, String recipeName);

  /// Removes the item identified by [id].
  void removeItem(String id);

  /// Removes all items sourced from [recipeId].
  void removeByRecipeId(String recipeId);

  /// Toggles the checked state of the item identified by [id].
  void toggleItem(String id);

  /// Removes all checked items.
  void clearChecked();

  /// Removes every item from the list.
  void clearAll();

  /// Returns `true` if [ingredientId] from [recipeId] is already on the list.
  bool isAdded(String ingredientId, String recipeId);
}
