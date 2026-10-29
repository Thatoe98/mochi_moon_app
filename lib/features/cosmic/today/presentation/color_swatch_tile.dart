import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';

/// A color from the content files, such as "#FF7F6E". The hex values are
/// content, not theme tokens, so this is the one place they become colors.
Color colorFromHex(String hex) =>
    Color(0xFF000000 | int.parse(hex.replaceFirst('#', ''), radix: 16));

/// A round swatch with the color's name, and an optional caption above it.
/// The name is the only thing a screen reader needs, so the swatch itself is
/// hidden from it.
class ColorSwatchTile extends StatelessWidget {
  const ColorSwatchTile({
    required this.name,
    required this.hex,
    this.caption,
    super.key,
  });

  final String name;
  final String hex;
  final String? caption;

  static const _size = 40.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: caption == null ? name : '$caption: $name',
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
        child: Row(
          children: [
            Container(
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: colorFromHex(hex),
                borderRadius: AppRadii.chipRadius,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (caption != null)
                    Text(caption!, style: theme.textTheme.bodySmall),
                  Text(name, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
