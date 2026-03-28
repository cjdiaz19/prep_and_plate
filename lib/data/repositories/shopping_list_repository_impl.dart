import '../../domain/entities/ingredient.dart';
import '../../domain/entities/shopping_list_item.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import '../datasources/shopping_list_local_data_source.dart';
import '../models/shopping_list_item_model.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListLocalDataSource _dataSource;

  const ShoppingListRepositoryImpl(
      {required ShoppingListLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  List<ShoppingListItem> getAll() =>
      _dataSource.getAll().map((m) => m.toEntity()).toList();

  @override
  void addIngredient(
      Ingredient ingredient, String recipeId, String recipeName) {
    if (_dataSource.exists(ingredient.id, recipeId)) return;
    _dataSource.add(ShoppingListItemModel(
      id: '${DateTime.now().millisecondsSinceEpoch}${ingredient.id}',
      ingredientId: ingredient.id,
      ingredientName: ingredient.name,
      amount: ingredient.amount,
      unit: ingredient.unit,
      recipeId: recipeId,
      recipeName: recipeName,
    ));
  }

  @override
  void removeItem(String id) => _dataSource.removeById(id);

  @override
  void removeByRecipeId(String recipeId) =>
      _dataSource.removeByRecipeId(recipeId);

  @override
  void toggleItem(String id) => _dataSource.toggle(id);

  @override
  void clearChecked() => _dataSource.clearChecked();

  @override
  void clearAll() => _dataSource.clearAll();

  @override
  bool isAdded(String ingredientId, String recipeId) =>
      _dataSource.exists(ingredientId, recipeId);
}
