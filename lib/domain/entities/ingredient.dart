/// Pure domain entity — no serialization, no Flutter imports.
class Ingredient {
  final String id;
  final String name;
  final double amount;
  final String unit;

  const Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  Ingredient copyWith({String? name, double? amount, String? unit}) =>
      Ingredient(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        unit: unit ?? this.unit,
      );
}
