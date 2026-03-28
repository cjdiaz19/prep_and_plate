import '../../entities/recipe.dart';
import '../../repositories/recipe_repository.dart';

class GetAllRecipes {
  final RecipeRepository _repository;
  const GetAllRecipes(this._repository);

  List<Recipe> call() => _repository.getAll();
}
