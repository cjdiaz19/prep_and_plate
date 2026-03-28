import '../../domain/entities/ingredient.dart';

/// Data-layer representation of [Ingredient].
/// Owns serialization — the domain entity stays serialization-free.
class IngredientModel {
  final String id;
  final String name;
  final double amount;
  final String unit;

  const IngredientModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  // ── Mapping ───────────────────────────────────────────────────────────────

  factory IngredientModel.fromEntity(Ingredient e) => IngredientModel(
        id: e.id,
        name: e.name,
        amount: e.amount,
        unit: e.unit,
      );

  Ingredient toEntity() =>
      Ingredient(id: id, name: name, amount: amount, unit: unit);

  // ── Serialization (ready for local DB / remote API) ───────────────────────

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      IngredientModel(
        id: json['id'] as String,
        name: json['name'] as String,
        amount: (json['amount'] as num).toDouble(),
        unit: json['unit'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'amount': amount,
        'unit': unit,
      };
}
