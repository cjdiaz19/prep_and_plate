import '../../domain/entities/recipe.dart';
import 'ingredient_model.dart';
import 'recipe_revision_model.dart';

class RecipeModel {
  final String id;
  final String title;
  final String description;
  final List<IngredientModel> ingredients;
  final List<String> steps;
  final int servings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RecipeRevisionModel> revisions;

  const RecipeModel({
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

  // ── Mapping ───────────────────────────────────────────────────────────────

  factory RecipeModel.fromEntity(Recipe e) => RecipeModel(
        id: e.id,
        title: e.title,
        description: e.description,
        ingredients: e.ingredients.map(IngredientModel.fromEntity).toList(),
        steps: e.steps,
        servings: e.servings,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        revisions:
            e.revisions.map(RecipeRevisionModel.fromEntity).toList(),
      );

  Recipe toEntity() => Recipe(
        id: id,
        title: title,
        description: description,
        ingredients: ingredients.map((m) => m.toEntity()).toList(),
        steps: steps,
        servings: servings,
        createdAt: createdAt,
        updatedAt: updatedAt,
        revisions: revisions.map((m) => m.toEntity()).toList(),
      );

  // ── Serialization ─────────────────────────────────────────────────────────

  factory RecipeModel.fromJson(Map<String, dynamic> json) => RecipeModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        ingredients: (json['ingredients'] as List)
            .map((i) => IngredientModel.fromJson(i as Map<String, dynamic>))
            .toList(),
        steps: List<String>.from(json['steps'] as List),
        servings: json['servings'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        revisions: (json['revisions'] as List)
            .map((r) =>
                RecipeRevisionModel.fromJson(r as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'steps': steps,
        'servings': servings,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'revisions': revisions.map((r) => r.toJson()).toList(),
      };
}
