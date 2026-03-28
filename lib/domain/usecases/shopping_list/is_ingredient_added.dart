import '../../repositories/shopping_list_repository.dart';

class IsIngredientAdded {
  final ShoppingListRepository _repository;
  const IsIngredientAdded(this._repository);

  bool call(String ingredientId, String recipeId) =>
      _repository.isAdded(ingredientId, recipeId);
}
