/// Shared formatting utilities used across presentation and data layers.
abstract final class Formatters {
  /// Formats a [double] amount, dropping unnecessary decimal places.
  /// e.g. 2.0 → "2", 0.5 → "0.5", 1.25 → "1.25"
  static String amount(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return double.parse(value.toStringAsFixed(2))
        .toString()
        .replaceAll(RegExp(r'\.?0+$'), '');
  }

  /// Formats a [DateTime] as "Mon DD, YYYY".
  static String shortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  /// Formats a [DateTime] as "Mon DD, YYYY · H:MM AM/PM".
  static String dateTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '${shortDate(dt)} · $h:$m $ampm';
  }

  /// Returns a food emoji representative of a recipe [title].
  static String recipeEmoji(String title) {
    final t = title.toLowerCase();
    if (t.contains('pasta') ||
        t.contains('spaghetti') ||
        t.contains('carbonara')) return '🍝';
    if (t.contains('ramen') ||
        t.contains('noodle') ||
        t.contains('soup')) return '🍜';
    if (t.contains('salad')) return '🥗';
    if (t.contains('avocado') || t.contains('toast')) return '🥑';
    if (t.contains('cake') ||
        t.contains('cheesecake') ||
        t.contains('dessert')) return '🍰';
    if (t.contains('smoothie') ||
        t.contains('shake') ||
        t.contains('juice')) return '🥤';
    if (t.contains('chicken')) return '🍗';
    if (t.contains('fish') ||
        t.contains('salmon') ||
        t.contains('cod')) return '🐟';
    if (t.contains('beef') ||
        t.contains('steak') ||
        t.contains('burger')) return '🥩';
    if (t.contains('pizza')) return '🍕';
    if (t.contains('taco') || t.contains('burrito')) return '🌮';
    if (t.contains('sushi') || t.contains('nigiri')) return '🍣';
    if (t.contains('egg') ||
        t.contains('breakfast') ||
        t.contains('pancake')) return '🍳';
    if (t.contains('bread') ||
        t.contains('focaccia') ||
        t.contains('cookie')) return '🍞';
    return '🍽️';
  }
}
