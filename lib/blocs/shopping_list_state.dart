import '../models/shopping_list_item.dart';

class ShoppingListState {
  final List<ShoppingListItem> items;

  const ShoppingListState({required this.items});

  ShoppingListState copyWith({List<ShoppingListItem>? items}) =>
      ShoppingListState(items: items ?? this.items);
}
