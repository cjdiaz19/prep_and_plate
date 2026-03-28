import '../../../domain/entities/recipe.dart';

class RecipeState {
  final List<Recipe> recipes;

  const RecipeState({required this.recipes});

  RecipeState copyWith({List<Recipe>? recipes}) =>
      RecipeState(recipes: recipes ?? this.recipes);
}
