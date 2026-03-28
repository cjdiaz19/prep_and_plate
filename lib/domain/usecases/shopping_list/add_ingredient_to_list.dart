import '../../entities/ingredient.dart';
import '../../repositories/shopping_list_repository.dart';

class AddIngredientToList {
  final ShoppingListRepository _repository;
  const AddIngredientToList(this._repository);

  void call(Ingredient ingredient, String recipeId, String recipeName) =>
      _repository.addIngredient(ingredient, recipeId, recipeName);
}
