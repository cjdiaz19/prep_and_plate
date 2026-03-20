import 'ingredient.dart';

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

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'ingredients': ingredients.map((i) => i.toMap()).toList(),
        'steps': steps,
        'servings': servings,
        'editedAt': editedAt.toIso8601String(),
        'changeNote': changeNote,
      };

  factory RecipeRevision.fromMap(Map<String, dynamic> map) => RecipeRevision(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        ingredients: (map['ingredients'] as List)
            .map((i) => Ingredient.fromMap(i as Map<String, dynamic>))
            .toList(),
        steps: List<String>.from(map['steps'] as List),
        servings: map['servings'] as int,
        editedAt: DateTime.parse(map['editedAt'] as String),
        changeNote: map['changeNote'] as String,
      );
}
