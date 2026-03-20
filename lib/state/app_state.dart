import 'package:flutter/widgets.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import '../models/recipe_revision.dart';
import '../models/shopping_list_item.dart';

class AppState extends ChangeNotifier {
  final List<Recipe> _recipes = [];
  final List<ShoppingListItem> _shoppingList = [];

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<ShoppingListItem> get shoppingList => List.unmodifiable(_shoppingList);

  AppState() {
    _seedData();
  }

  void _seedData() {
    final now = DateTime.now();
    _recipes.addAll([
      Recipe(
        id: '1',
        title: 'Classic Spaghetti Carbonara',
        description:
            'A rich and creamy Italian pasta dish made with eggs, cheese, pancetta, and black pepper.',
        servings: 4,
        ingredients: [
          Ingredient(id: 'i1', name: 'Spaghetti', amount: 400, unit: 'g'),
          Ingredient(id: 'i2', name: 'Pancetta', amount: 150, unit: 'g'),
          Ingredient(id: 'i3', name: 'Eggs', amount: 4, unit: 'large'),
          Ingredient(id: 'i4', name: 'Pecorino Romano', amount: 100, unit: 'g'),
          Ingredient(id: 'i5', name: 'Black Pepper', amount: 2, unit: 'tsp'),
          Ingredient(id: 'i6', name: 'Salt', amount: 1, unit: 'tbsp'),
        ],
        steps: [
          'Bring a large pot of salted water to a boil and cook spaghetti al dente per package directions.',
          'Fry the pancetta in a large skillet over medium heat until golden and crispy, about 5 minutes.',
          'Whisk together eggs and grated Pecorino Romano in a bowl until combined.',
          'Reserve 1 cup of pasta cooking water, then drain the spaghetti.',
          'Remove skillet from heat. Add hot pasta to the pancetta and toss to combine.',
          'Pour the egg-cheese mixture over the pasta, tossing quickly to coat. Add pasta water a splash at a time to create a silky sauce.',
          'Season generously with freshly cracked black pepper and serve immediately.',
        ],
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      Recipe(
        id: '2',
        title: 'Creamy Avocado Toast',
        description:
            'Simple, nutritious avocado toast elevated with a squeeze of lemon and a pinch of chili flakes.',
        servings: 2,
        ingredients: [
          Ingredient(id: 'i7', name: 'Sourdough Bread', amount: 2, unit: 'slices'),
          Ingredient(id: 'i8', name: 'Ripe Avocados', amount: 1, unit: 'large'),
          Ingredient(id: 'i9', name: 'Lemon Juice', amount: 1, unit: 'tbsp'),
          Ingredient(id: 'i10', name: 'Red Pepper Flakes', amount: 0.5, unit: 'tsp'),
          Ingredient(id: 'i11', name: 'Salt', amount: 0.25, unit: 'tsp'),
          Ingredient(id: 'i12', name: 'Olive Oil', amount: 1, unit: 'tsp'),
        ],
        steps: [
          'Toast the sourdough bread until golden and crispy.',
          'Halve the avocado, remove the pit, and scoop the flesh into a bowl.',
          'Mash the avocado with lemon juice and salt until smooth but slightly chunky.',
          'Drizzle olive oil over the toast.',
          'Spread the avocado mixture generously over each slice.',
          'Top with red pepper flakes and an extra pinch of salt. Serve immediately.',
        ],
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      Recipe(
        id: '3',
        title: 'Blueberry Banana Smoothie',
        description:
            'A thick, refreshing smoothie packed with antioxidants and natural sweetness.',
        servings: 1,
        ingredients: [
          Ingredient(id: 'i13', name: 'Frozen Blueberries', amount: 1, unit: 'cup'),
          Ingredient(id: 'i14', name: 'Banana', amount: 1, unit: 'medium'),
          Ingredient(id: 'i15', name: 'Greek Yogurt', amount: 0.5, unit: 'cup'),
          Ingredient(id: 'i16', name: 'Almond Milk', amount: 0.75, unit: 'cup'),
          Ingredient(id: 'i17', name: 'Honey', amount: 1, unit: 'tbsp'),
          Ingredient(id: 'i18', name: 'Vanilla Extract', amount: 0.5, unit: 'tsp'),
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
    ]);
  }

  Recipe? getRecipeById(String id) {
    try {
      return _recipes.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  void addRecipe(Recipe recipe) {
    _recipes.add(recipe);
    notifyListeners();
  }

  void updateRecipe(String id, Recipe updated, {String changeNote = ''}) {
    final index = _recipes.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final old = _recipes[index];
    final revision = RecipeRevision(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: old.title,
      description: old.description,
      ingredients: old.ingredients,
      steps: old.steps,
      servings: old.servings,
      editedAt: DateTime.now(),
      changeNote: changeNote.isEmpty ? 'Recipe updated' : changeNote,
    );

    _recipes[index] = updated.copyWith(
      revisions: [...old.revisions, revision],
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void deleteRecipe(String id) {
    _recipes.removeWhere((r) => r.id == id);
    _shoppingList.removeWhere((item) => item.recipeId == id);
    notifyListeners();
  }

  void addIngredientToShoppingList(
    Ingredient ingredient,
    String recipeId,
    String recipeName,
  ) {
    final existingIndex = _shoppingList.indexWhere(
      (item) => item.ingredientId == ingredient.id && item.recipeId == recipeId,
    );
    if (existingIndex != -1) return;

    _shoppingList.add(ShoppingListItem(
      id: '${DateTime.now().millisecondsSinceEpoch}${ingredient.id}',
      ingredientId: ingredient.id,
      ingredientName: ingredient.name,
      amount: ingredient.amount,
      unit: ingredient.unit,
      recipeId: recipeId,
      recipeName: recipeName,
    ));
    notifyListeners();
  }

  void removeFromShoppingList(String id) {
    _shoppingList.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void toggleShoppingItem(String id) {
    final index = _shoppingList.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _shoppingList[index] =
        _shoppingList[index].copyWith(isChecked: !_shoppingList[index].isChecked);
    notifyListeners();
  }

  void clearCheckedItems() {
    _shoppingList.removeWhere((item) => item.isChecked);
    notifyListeners();
  }

  void clearAllShoppingItems() {
    _shoppingList.clear();
    notifyListeners();
  }

  bool isIngredientInShoppingList(String ingredientId, String recipeId) {
    return _shoppingList
        .any((item) => item.ingredientId == ingredientId && item.recipeId == recipeId);
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>()!
        .notifier!;
  }
}
