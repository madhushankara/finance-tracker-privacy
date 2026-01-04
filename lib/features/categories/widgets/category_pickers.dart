import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';

const List<String> kCategoryIconKeys = <String>[
  'shopping',
  'food',
  'transport',
  'home',
  'health',
  'travel',
  'salary',
  'gift',
  'education',
  'other',
];

const List<int> kCategoryColorHexPalette = <int>[
  0xFF64B5F6, // blue
  0xFF81C784, // green
  0xFFFFB74D, // orange
  0xFFE57373, // red
  0xFFBA68C8, // purple
  0xFF4DB6AC, // teal
  0xFFAED581, // lime
  0xFF90A4AE, // blueGrey
];

final class IconPickerGrid extends StatelessWidget {
  const IconPickerGrid({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.enabled,
  });

  final String? selected;
  final ValueChanged<String> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: kCategoryIconKeys.map((key) {
        final isSelected = key == (selected ?? 'other');
        return InkWell(
          onTap: enabled ? () => onSelected(key) : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.8)
                    : cs.outline.withValues(alpha: 0.45),
              ),
              color: cs.surface,
            ),
            child: Center(
              child: Icon(
                _iconFor(key),
                color: cs.onSurface.withValues(alpha: isSelected ? 0.95 : 0.75),
                size: 20,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

final class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.selectedHex,
    required this.onSelected,
    required this.enabled,
  });

  final int? selectedHex;
  final ValueChanged<int> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: kCategoryColorHexPalette.map((hex) {
        final isSelected = hex == selectedHex;
        return InkWell(
          onTap: enabled ? () => onSelected(hex) : null,
          borderRadius: BorderRadius.circular(99),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(hex),
              border: Border.all(
                color: isSelected
                    ? cs.onSurface.withValues(alpha: 0.8)
                    : cs.outline.withValues(alpha: 0.35),
                width: isSelected ? 2 : 1,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

IconData _iconFor(String key) {
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
    _ => Icons.category_outlined,
  };
}
