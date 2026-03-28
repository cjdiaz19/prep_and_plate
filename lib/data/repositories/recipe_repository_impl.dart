import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_local_data_source.dart';
import '../models/recipe_model.dart';

/// Bridges the domain [RecipeRepository] contract and the data source.
/// Maps between domain entities and data models — the domain stays ignorant
/// of how or where data is stored.
class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeLocalDataSource _dataSource;

  const RecipeRepositoryImpl({required RecipeLocalDataSource dataSource})
      : _dataSource = dataSource;

  @override
  List<Recipe> getAll() =>
      _dataSource.getAll().map((m) => m.toEntity()).toList();

  @override
  Recipe? getById(String id) => _dataSource.getById(id)?.toEntity();

  @override
  void add(Recipe recipe) =>
      _dataSource.add(RecipeModel.fromEntity(recipe));

  @override
  void update(String id, Recipe updated) =>
      _dataSource.update(id, RecipeModel.fromEntity(updated));

  @override
  void delete(String id) => _dataSource.delete(id);
}
