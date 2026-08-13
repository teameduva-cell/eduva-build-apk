import 'package:flutter/material.dart';

/// A reusable, read-only pill displaying a category/subject label.
///
/// Purely decorative and non-interactive. Designed for displaying a
/// category over thumbnails or inside cards.
class CategoryTag extends StatelessWidget {
  final String label;

  const CategoryTag({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}