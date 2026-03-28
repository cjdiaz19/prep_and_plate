import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';

class AddRecipe {
  final RecipeRepository _repository;
  const AddRecipe(this._repository);

  void call(Recipe recipe) => _repository.add(recipe);
}
