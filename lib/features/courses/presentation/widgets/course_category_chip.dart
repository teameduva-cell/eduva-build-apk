import 'package:flutter/material.dart';

/// A selectable chip representing a course category/subject filter.
///
/// Stateless and controlled: the parent widget owns the selected state.
class CourseCategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const CourseCategoryChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap?.call(),
      showCheckmark: false,
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      side: BorderSide(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
    );
  }
}