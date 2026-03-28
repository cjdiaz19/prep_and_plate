import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';

class GetRecipeById {
  final RecipeRepository _repository;
  const GetRecipeById(this._repository);

  Recipe? call(String id) => _repository.getById(id);
}
