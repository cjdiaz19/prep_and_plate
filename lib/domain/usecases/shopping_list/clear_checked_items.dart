import '../../repositories/shopping_list_repository.dart';

class ClearCheckedItems {
  final ShoppingListRepository _repository;
  const ClearCheckedItems(this._repository);

  void call() => _repository.clearChecked();
}
