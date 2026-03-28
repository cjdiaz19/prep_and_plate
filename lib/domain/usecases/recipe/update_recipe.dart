import '../../entities/recipe.dart';
import '../../entities/recipe_revision.dart';
import '../../repositories/recipe_repository.dart';

/// Saves an updated recipe and snapshots the previous state as a revision.
/// Revision creation is a domain business rule — it lives here, not in the
/// presentation (Cubit) or data (Repository) layers.
class UpdateRecipe {
  final RecipeRepository _repository;
  const UpdateRecipe(this._repository);

  void call(String id, Recipe updated, {String changeNote = ''}) {
    final existing = _repository.getById(id);
    if (existing == null) return;

    final revision = RecipeRevision(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: existing.title,
      description: existing.description,
      ingredients: existing.ingredients,
      steps: existing.steps,
      servings: existing.servings,
      editedAt: DateTime.now(),
      changeNote: changeNote.isEmpty ? 'Recipe updated' : changeNote,
    );

    _repository.update(
      id,
      updated.copyWith(
        revisions: [...existing.revisions, revision],
        updatedAt: DateTime.now(),
      ),
    );
  }
}
