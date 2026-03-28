import '../../repositories/shopping_list_repository.dart';

class ClearAllItems {
  final ShoppingListRepository _repository;
  const ClearAllItems(this._repository);

  void call() => _repository.clearAll();
}
