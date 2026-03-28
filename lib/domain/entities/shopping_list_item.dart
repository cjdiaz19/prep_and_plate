/// A single item on the shopping list derived from a recipe ingredient.
class ShoppingListItem {
  final String id;
  final String ingredientId;
  final String ingredientName;
  final double amount;
  final String unit;
  final bool isChecked;
  final String? recipeId;
  final String? recipeName;

  const ShoppingListItem({
    required this.id,
    required this.ingredientId,
    required this.ingredientName,
    required this.amount,
    required this.unit,
    this.isChecked = false,
    this.recipeId,
    this.recipeName,
  });

  ShoppingListItem copyWith({bool? isChecked, double? amount}) =>
      ShoppingListItem(
        id: id,
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        amount: amount ?? this.amount,
        unit: unit,
        isChecked: isChecked ?? this.isChecked,
        recipeId: recipeId,
        recipeName: recipeName,
      );
}
