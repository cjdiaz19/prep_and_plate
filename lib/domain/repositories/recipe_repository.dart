import '../entities/recipe.dart';

/// Contract for all recipe persistence operations.
/// The domain layer depends only on this interface, never on any implementation.
abstract interface class RecipeRepository {
  /// Returns all stored recipes.
  List<Recipe> getAll();

  /// Returns the recipe with [id], or `null` if not found.
  Recipe? getById(String id);

  /// Persists a new [recipe].
  void add(Recipe recipe);

  /// Replaces the recipe identified by [id] with [updated].
  void update(String id, Recipe updated);

  /// Removes the recipe identified by [id].
  void delete(String id);
}
