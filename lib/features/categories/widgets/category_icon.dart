import 'package:flutter/material.dart';

final class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    super.key,
    required this.iconKey,
    required this.colorHex,
    this.size = 22,
  });

  final String? iconKey;
  final int? colorHex;
  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final icon = _iconFor(iconKey);

    final Color accent = colorHex == null
        ? cs.primary.withValues(alpha: 0.75)
        : Color(colorHex!).withValues(alpha: 0.9);

    return Icon(icon, size: size, color: accent);
  }
}

IconData _iconFor(String? key) {
  return switch (key) {
    'shopping' => Icons.shopping_bag_outlined,
    'food' => Icons.restaurant_outlined,
    'transport' => Icons.directions_car_filled_outlined,
    'home' => Icons.home_outlined,
    'health' => Icons.health_and_safety_outlined,
    'travel' => Icons.flight_takeoff_outlined,
    'salary' => Icons.payments_outlined,
    'gift' => Icons.card_giftcard_outlined,
    'education' => Icons.school_outlined,
    'other' || null => Icons.category_outlined,
    _ => Icons.category_outlined,
  };
}
