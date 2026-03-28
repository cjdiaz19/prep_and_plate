import 'ingredient.dart';

/// Immutable snapshot of a [Recipe] captured before each edit.
class RecipeRevision {
  final String id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int servings;
  final DateTime editedAt;
  final String changeNote;

  const RecipeRevision({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.editedAt,
    required this.changeNote,
  });
}
