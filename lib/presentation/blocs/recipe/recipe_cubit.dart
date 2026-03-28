import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/recipe.dart';
import '../../../domain/usecases/recipe/add_recipe.dart';
import '../../../domain/usecases/recipe/delete_recipe.dart';
import '../../../domain/usecases/recipe/get_all_recipes.dart';
import '../../../domain/usecases/recipe/get_recipe_by_id.dart';
import '../../../domain/usecases/recipe/update_recipe.dart';
import 'recipe_state.dart';

class RecipeCubit extends Cubit<RecipeState> {
  final GetAllRecipes _getAllRecipes;
  final GetRecipeById _getRecipeById;
  final AddRecipe _addRecipe;
  final UpdateRecipe _updateRecipe;
  final DeleteRecipe _deleteRecipe;

  RecipeCubit({
    required GetAllRecipes getAllRecipes,
    required GetRecipeById getRecipeById,
    required AddRecipe addRecipe,
    required UpdateRecipe updateRecipe,
    required DeleteRecipe deleteRecipe,
  })  : _getAllRecipes = getAllRecipes,
        _getRecipeById = getRecipeById,
        _addRecipe = addRecipe,
        _updateRecipe = updateRecipe,
        _deleteRecipe = deleteRecipe,
        super(RecipeState(recipes: getAllRecipes()));

  Recipe? getById(String id) => _getRecipeById(id);

  void addRecipe(Recipe recipe) {
    _addRecipe(recipe);
    emit(RecipeState(recipes: _getAllRecipes()));
  }

  void updateRecipe(String id, Recipe updated, {String changeNote = ''}) {
    _updateRecipe(id, updated, changeNote: changeNote);
    emit(RecipeState(recipes: _getAllRecipes()));
  }

  void deleteRecipe(String id) {
    _deleteRecipe(id);
    emit(RecipeState(recipes: _getAllRecipes()));
  }
}
