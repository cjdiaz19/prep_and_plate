import 'ingredient.dart';
import 'recipe_revision.dart';

/// Core recipe entity — the central business object of the app.
class Recipe {
  final String id;
  final String title;
  final String description;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int servings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RecipeRevision> revisions;

  const Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.createdAt,
    required this.updatedAt,
    this.revisions = const [],
  });

  Recipe copyWith({
    String? title,
    String? description,
    List<Ingredient>? ingredients,
    List<String>? steps,
    int? servings,
    DateTime? updatedAt,
    List<RecipeRevision>? revisions,
  }) =>
      Recipe(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        ingredients: ingredients ?? this.ingredients,
        steps: steps ?? this.steps,
        servings: servings ?? this.servings,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        revisions: revisions ?? this.revisions,
      );
}
