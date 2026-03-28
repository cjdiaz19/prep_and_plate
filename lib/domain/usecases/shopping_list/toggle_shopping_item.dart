import '../../repositories/shopping_list_repository.dart';

class ToggleShoppingItem {
  final ShoppingListRepository _repository;
  const ToggleShoppingItem(this._repository);

  void call(String id) => _repository.toggleItem(id);
}
