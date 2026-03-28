import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/recipe_local_data_source.dart';
import 'data/datasources/shopping_list_local_data_source.dart';
import 'data/repositories/recipe_repository_impl.dart';
import 'data/repositories/shopping_list_repository_impl.dart';
import 'domain/usecases/recipe/add_recipe.dart';
import 'domain/usecases/recipe/delete_recipe.dart';
import 'domain/usecases/recipe/get_all_recipes.dart';
import 'domain/usecases/recipe/get_recipe_by_id.dart';
import 'domain/usecases/recipe/update_recipe.dart';
import 'domain/usecases/shopping_list/add_ingredient_to_list.dart';
import 'domain/usecases/shopping_list/clear_all_items.dart';
import 'domain/usecases/shopping_list/clear_checked_items.dart';
import 'domain/usecases/shopping_list/get_shopping_list.dart';
import 'domain/usecases/shopping_list/is_ingredient_added.dart';
import 'domain/usecases/shopping_list/remove_items_by_recipe.dart';
import 'domain/usecases/shopping_list/remove_shopping_item.dart';
import 'domain/usecases/shopping_list/toggle_shopping_item.dart';
import 'presentation/blocs/recipe/recipe_cubit.dart';
import 'presentation/blocs/shopping_list/shopping_list_cubit.dart';
import 'presentation/pages/home_page.dart';

void main() {
  runApp(const PrepAndPlateApp());
}

class PrepAndPlateApp extends StatelessWidget {
  const PrepAndPlateApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Data sources ──────────────────────────────────────────────────────────
    final recipeDataSource = RecipeLocalDataSourceImpl();
    final shoppingDataSource = ShoppingListLocalDataSourceImpl();

    // ── Repositories ──────────────────────────────────────────────────────────
    final recipeRepo =
        RecipeRepositoryImpl(dataSource: recipeDataSource);
    final shoppingRepo =
        ShoppingListRepositoryImpl(dataSource: shoppingDataSource);

    // ── Recipe use cases ──────────────────────────────────────────────────────
    final getAllRecipes = GetAllRecipes(recipeRepo);
    final getRecipeById = GetRecipeById(recipeRepo);
    final addRecipe = AddRecipe(recipeRepo);
    final updateRecipe = UpdateRecipe(recipeRepo);
    final deleteRecipe = DeleteRecipe(recipeRepo);

    // ── Shopping list use cases ───────────────────────────────────────────────
    final getShoppingList = GetShoppingList(shoppingRepo);
    final addIngredientToList = AddIngredientToList(shoppingRepo);
    final removeShoppingItem = RemoveShoppingItem(shoppingRepo);
    final removeItemsByRecipe = RemoveItemsByRecipe(shoppingRepo);
    final toggleShoppingItem = ToggleShoppingItem(shoppingRepo);
    final clearCheckedItems = ClearCheckedItems(shoppingRepo);
    final clearAllItems = ClearAllItems(shoppingRepo);
    final isIngredientAdded = IsIngredientAdded(shoppingRepo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RecipeCubit(
            getAllRecipes: getAllRecipes,
            getRecipeById: getRecipeById,
            addRecipe: addRecipe,
            updateRecipe: updateRecipe,
            deleteRecipe: deleteRecipe,
          ),
        ),
        BlocProvider(
          create: (_) => ShoppingListCubit(
            getShoppingList: getShoppingList,
            addIngredientToList: addIngredientToList,
            removeShoppingItem: removeShoppingItem,
            removeItemsByRecipe: removeItemsByRecipe,
            toggleShoppingItem: toggleShoppingItem,
            clearCheckedItems: clearCheckedItems,
            clearAllItems: clearAllItems,
            isIngredientAdded: isIngredientAdded,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Prep & Plate',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(),
        home: const HomePage(),
      ),
    );
  }
}
