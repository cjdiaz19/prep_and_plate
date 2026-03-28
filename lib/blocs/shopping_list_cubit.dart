import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ingredient.dart';
import '../models/shopping_list_item.dart';
import 'shopping_list_state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit() : super(const ShoppingListState(items: []));

  void addIngredient(
    Ingredient ingredient,
    String recipeId,
    String recipeName,
  ) {
    final exists = state.items.any(
      (i) => i.ingredientId == ingredient.id && i.recipeId == recipeId,
    );
    if (exists) return;

    emit(state.copyWith(items: [
      ...state.items,
      ShoppingListItem(
        id: '${DateTime.now().millisecondsSinceEpoch}${ingredient.id}',
        ingredientId: ingredient.id,
        ingredientName: ingredient.name,
        amount: ingredient.amount,
        unit: ingredient.unit,
        recipeId: recipeId,
        recipeName: recipeName,
      ),
    ]));
  }

  void removeItem(String id) {
    emit(state.copyWith(items: state.items.where((i) => i.id != id).toList()));
  }

  void removeByRecipeId(String recipeId) {
    emit(state.copyWith(
      items: state.items.where((i) => i.recipeId != recipeId).toList(),
    ));
  }

  void toggleItem(String id) {
    final newItems = state.items.map((item) {
      if (item.id == id) return item.copyWith(isChecked: !item.isChecked);
      return item;
    }).toList();
    emit(state.copyWith(items: newItems));
  }

  void clearChecked() {
    emit(state.copyWith(items: state.items.where((i) => !i.isChecked).toList()));
  }

  void clearAll() {
    emit(const ShoppingListState(items: []));
  }

  bool isIngredientAdded(String ingredientId, String recipeId) {
    return state.items.any(
      (i) => i.ingredientId == ingredientId && i.recipeId == recipeId,
    );
  }
}
