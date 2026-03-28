import '../models/ingredient_model.dart';
import '../models/recipe_model.dart';

/// Contract for the recipe local data source.
abstract interface class RecipeLocalDataSource {
  List<RecipeModel> getAll();
  RecipeModel? getById(String id);
  void add(RecipeModel model);
  void update(String id, RecipeModel model);
  void delete(String id);
}

/// In-memory implementation — swap for SQLite/Hive/SharedPreferences
/// without touching the domain or presentation layers.
class RecipeLocalDataSourceImpl implements RecipeLocalDataSource {
  final List<RecipeModel> _store;

  RecipeLocalDataSourceImpl() : _store = _seedData();

  // ── RecipeLocalDataSource ─────────────────────────────────────────────────

  @override
  List<RecipeModel> getAll() => List.unmodifiable(_store);

  @override
  RecipeModel? getById(String id) {
    try {
      return _store.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(RecipeModel model) => _store.add(model);

  @override
  void update(String id, RecipeModel model) {
    final index = _store.indexWhere((r) => r.id == id);
    if (index != -1) _store[index] = model;
  }

  @override
  void delete(String id) => _store.removeWhere((r) => r.id == id);

  // ── Seed data ─────────────────────────────────────────────────────────────

  static List<RecipeModel> _seedData() {
    final now = DateTime.now();
    return [
      RecipeModel(
        id: '1',
        title: 'Classic Spaghetti Carbonara',
        description:
            'A rich and creamy Italian pasta dish made with eggs, cheese, pancetta, and black pepper.',
        servings: 4,
        ingredients: [
          IngredientModel(id: 'i1', name: 'Spaghetti', amount: 400, unit: 'g'),
          IngredientModel(id: 'i2', name: 'Pancetta', amount: 150, unit: 'g'),
          IngredientModel(id: 'i3', name: 'Eggs', amount: 4, unit: 'large'),
          IngredientModel(
              id: 'i4', name: 'Pecorino Romano', amount: 100, unit: 'g'),
          IngredientModel(
              id: 'i5', name: 'Black Pepper', amount: 2, unit: 'tsp'),
          IngredientModel(id: 'i6', name: 'Salt', amount: 1, unit: 'tbsp'),
        ],
        steps: [
          'Bring a large pot of salted water to a boil and cook spaghetti al dente.',
          'Fry the pancetta over medium heat until golden and crispy, about 5 minutes.',
          'Whisk together eggs and grated Pecorino Romano in a bowl.',
          'Reserve 1 cup of pasta water, then drain the spaghetti.',
          'Off heat, add pasta to the pancetta and toss to combine.',
          'Pour the egg-cheese mixture over, tossing quickly. Add pasta water to create a silky sauce.',
          'Season with freshly cracked black pepper and serve immediately.',
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      RecipeModel(
        id: '2',
        title: 'Creamy Avocado Toast',
        description:
            'Simple, nutritious avocado toast elevated with lemon and chili flakes.',
        servings: 2,
        ingredients: [
          IngredientModel(
              id: 'i7', name: 'Sourdough Bread', amount: 2, unit: 'slices'),
          IngredientModel(
              id: 'i8', name: 'Ripe Avocados', amount: 1, unit: 'large'),
          IngredientModel(
              id: 'i9', name: 'Lemon Juice', amount: 1, unit: 'tbsp'),
          IngredientModel(
              id: 'i10',
              name: 'Red Pepper Flakes',
              amount: 0.5,
              unit: 'tsp'),
          IngredientModel(id: 'i11', name: 'Salt', amount: 0.25, unit: 'tsp'),
          IngredientModel(
              id: 'i12', name: 'Olive Oil', amount: 1, unit: 'tsp'),
        ],
        steps: [
          'Toast the sourdough bread until golden and crispy.',
          'Halve the avocado, remove the pit, and scoop the flesh into a bowl.',
          'Mash with lemon juice and salt until smooth but slightly chunky.',
          'Drizzle olive oil over the toast.',
          'Spread avocado mixture generously over each slice.',
          'Top with red pepper flakes and an extra pinch of salt.',
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      RecipeModel(
        id: '3',
        title: 'Blueberry Banana Smoothie',
        description:
            'A thick, refreshing smoothie packed with antioxidants and natural sweetness.',
        servings: 1,
        ingredients: [
          IngredientModel(
              id: 'i13', name: 'Frozen Blueberries', amount: 1, unit: 'cup'),
          IngredientModel(
              id: 'i14', name: 'Banana', amount: 1, unit: 'medium'),
          IngredientModel(
              id: 'i15', name: 'Greek Yogurt', amount: 0.5, unit: 'cup'),
          IngredientModel(
              id: 'i16', name: 'Almond Milk', amount: 0.75, unit: 'cup'),
          IngredientModel(id: 'i17', name: 'Honey', amount: 1, unit: 'tbsp'),
          IngredientModel(
              id: 'i18',
              name: 'Vanilla Extract',
              amount: 0.5,
              unit: 'tsp'),
        ],
        steps: [
          'Add almond milk and Greek yogurt to the blender first.',
          'Add frozen blueberries, banana, honey, and vanilla extract.',
          'Blend on high until completely smooth, about 60 seconds.',
          'Taste and adjust sweetness with more honey if desired.',
          'Pour into a glass and enjoy immediately.',
        ],
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }
}
