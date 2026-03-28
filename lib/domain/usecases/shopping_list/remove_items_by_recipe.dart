import '../../repositories/shopping_list_repository.dart';

class RemoveItemsByRecipe {
  final ShoppingListRepository _repository;
  const RemoveItemsByRecipe(this._repository);

  void call(String recipeId) => _repository.removeByRecipeId(recipeId);
}
