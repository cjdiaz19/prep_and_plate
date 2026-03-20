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

  Ingredient copyWith({String? name, double? amount, String? unit}) {
    return Ingredient(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'amount': amount,
        'unit': unit,
      };

  factory Ingredient.fromMap(Map<String, dynamic> map) => Ingredient(
        id: map['id'] as String,
        name: map['name'] as String,
        amount: (map['amount'] as num).toDouble(),
        unit: map['unit'] as String,
      );
}
