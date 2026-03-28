import '../../entities/shopping_list_item.dart';
import '../../repositories/shopping_list_repository.dart';

class GetShoppingList {
  final ShoppingListRepository _repository;
  const GetShoppingList(this._repository);

  List<ShoppingListItem> call() => _repository.getAll();
}
