import '../../repositories/recipe_repository.dart';

class DeleteRecipe {
  final RecipeRepository _repository;
  const DeleteRecipe(this._repository);

  void call(String id) => _repository.delete(id);
}
