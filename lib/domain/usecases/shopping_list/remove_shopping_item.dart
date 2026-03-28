import '../../repositories/shopping_list_repository.dart';

class RemoveShoppingItem {
  final ShoppingListRepository _repository;
  const RemoveShoppingItem(this._repository);

  void call(String id) => _repository.removeItem(id);
}
