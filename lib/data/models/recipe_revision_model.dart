import '../../domain/entities/recipe_revision.dart';
import 'ingredient_model.dart';

class RecipeRevisionModel {
  final String id;
  final String title;
  final String description;
  final List<IngredientModel> ingredients;
  final List<String> steps;
  final int servings;
  final DateTime editedAt;
  final String changeNote;

  const RecipeRevisionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.servings,
    required this.editedAt,
    required this.changeNote,
  });

  // ── Mapping ───────────────────────────────────────────────────────────────

  factory RecipeRevisionModel.fromEntity(RecipeRevision e) =>
      RecipeRevisionModel(
        id: e.id,
        title: e.title,
        description: e.description,
        ingredients:
            e.ingredients.map(IngredientModel.fromEntity).toList(),
        steps: e.steps,
        servings: e.servings,
        editedAt: e.editedAt,
        changeNote: e.changeNote,
      );

  RecipeRevision toEntity() => RecipeRevision(
        id: id,
        title: title,
        description: description,
        ingredients: ingredients.map((m) => m.toEntity()).toList(),
        steps: steps,
        servings: servings,
        editedAt: editedAt,
        changeNote: changeNote,
      );

  // ── Serialization ─────────────────────────────────────────────────────────

  factory RecipeRevisionModel.fromJson(Map<String, dynamic> json) =>
      RecipeRevisionModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        ingredients: (json['ingredients'] as List)
            .map((i) => IngredientModel.fromJson(i as Map<String, dynamic>))
            .toList(),
        steps: List<String>.from(json['steps'] as List),
        servings: json['servings'] as int,
        editedAt: DateTime.parse(json['editedAt'] as String),
        changeNote: json['changeNote'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'steps': steps,
        'servings': servings,
        'editedAt': editedAt.toIso8601String(),
        'changeNote': changeNote,
      };
}
