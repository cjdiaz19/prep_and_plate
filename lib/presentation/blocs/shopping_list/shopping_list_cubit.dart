import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/ingredient.dart';
import '../../../domain/usecases/shopping_list/add_ingredient_to_list.dart';
import '../../../domain/usecases/shopping_list/clear_all_items.dart';
import '../../../domain/usecases/shopping_list/clear_checked_items.dart';
import '../../../domain/usecases/shopping_list/get_shopping_list.dart';
import '../../../domain/usecases/shopping_list/is_ingredient_added.dart';
import '../../../domain/usecases/shopping_list/remove_items_by_recipe.dart';
import '../../../domain/usecases/shopping_list/remove_shopping_item.dart';
import '../../../domain/usecases/shopping_list/toggle_shopping_item.dart';
import 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  final GetShoppingList _getShoppingList;
  final AddIngredientToList _addIngredientToList;
  final RemoveShoppingItem _removeShoppingItem;
  final RemoveItemsByRecipe _removeItemsByRecipe;
  final ToggleShoppingItem _toggleShoppingItem;
  final ClearCheckedItems _clearCheckedItems;
  final ClearAllItems _clearAllItems;
  final IsIngredientAdded _isIngredientAdded;

  ShoppingListCubit({
    required GetShoppingList getShoppingList,
    required AddIngredientToList addIngredientToList,
    required RemoveShoppingItem removeShoppingItem,
    required RemoveItemsByRecipe removeItemsByRecipe,
    required ToggleShoppingItem toggleShoppingItem,
    required ClearCheckedItems clearCheckedItems,
    required ClearAllItems clearAllItems,
    required IsIngredientAdded isIngredientAdded,
  })  : _getShoppingList = getShoppingList,
        _addIngredientToList = addIngredientToList,
        _removeShoppingItem = removeShoppingItem,
        _removeItemsByRecipe = removeItemsByRecipe,
        _toggleShoppingItem = toggleShoppingItem,
        _clearCheckedItems = clearCheckedItems,
        _clearAllItems = clearAllItems,
        _isIngredientAdded = isIngredientAdded,
        super(ShoppingListState(items: getShoppingList()));

  void _refresh() => emit(ShoppingListState(items: _getShoppingList()));

  void addIngredient(Ingredient ingredient, String recipeId, String recipeName) {
    _addIngredientToList(ingredient, recipeId, recipeName);
    _refresh();
  }

  void removeItem(String id) {
    _removeShoppingItem(id);
    _refresh();
  }

  void removeByRecipeId(String recipeId) {
    _removeItemsByRecipe(recipeId);
    _refresh();
  }

  void toggleItem(String id) {
    _toggleShoppingItem(id);
    _refresh();
  }

  void clearChecked() {
    _clearCheckedItems();
    _refresh();
  }

  void clearAll() {
    _clearAllItems();
    _refresh();
  }

  bool isIngredientAdded(String ingredientId, String recipeId) =>
      _isIngredientAdded(ingredientId, recipeId);
}
