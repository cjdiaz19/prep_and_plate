import '../../domain/entities/shopping_list_item.dart';

class ShoppingListItemModel {
  final String id;
  final String ingredientId;
  final String ingredientName;
  final double amount;
  final String unit;
  final bool isChecked;
  final String? recipeId;
  final String? recipeName;

  const ShoppingListItemModel({
    required this.id,
    required this.ingredientId,
    required this.ingredientName,
    required this.amount,
    required this.unit,
    this.isChecked = false,
    this.recipeId,
    this.recipeName,
  });

  // ── Mapping ───────────────────────────────────────────────────────────────

  factory ShoppingListItemModel.fromEntity(ShoppingListItem e) =>
      ShoppingListItemModel(
        id: e.id,
        ingredientId: e.ingredientId,
        ingredientName: e.ingredientName,
        amount: e.amount,
        unit: e.unit,
        isChecked: e.isChecked,
        recipeId: e.recipeId,
        recipeName: e.recipeName,
      );

  ShoppingListItem toEntity() => ShoppingListItem(
        id: id,
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        amount: amount,
        unit: unit,
        isChecked: isChecked,
        recipeId: recipeId,
        recipeName: recipeName,
      );

  ShoppingListItemModel copyWith({bool? isChecked}) =>
      ShoppingListItemModel(
        id: id,
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        amount: amount,
        unit: unit,
        isChecked: isChecked ?? this.isChecked,
        recipeId: recipeId,
        recipeName: recipeName,
      );

  // ── Serialization ─────────────────────────────────────────────────────────

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) =>
      ShoppingListItemModel(
        id: json['id'] as String,
        ingredientId: json['ingredientId'] as String,
        ingredientName: json['ingredientName'] as String,
        amount: (json['amount'] as num).toDouble(),
        unit: json['unit'] as String,
        isChecked: json['isChecked'] as bool? ?? false,
        recipeId: json['recipeId'] as String?,
        recipeName: json['recipeName'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ingredientId': ingredientId,
        'ingredientName': ingredientName,
        'amount': amount,
        'unit': unit,
        'isChecked': isChecked,
        'recipeId': recipeId,
        'recipeName': recipeName,
      };
}
