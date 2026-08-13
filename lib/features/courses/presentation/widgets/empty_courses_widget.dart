import 'package:flutter/material.dart';

/// Reusable empty-state widget for the Courses feature.
///
/// This widget is purely presentational — it has no knowledge of a
/// repository, datasource, use case, or state management solution. The
/// parent screen decides which message, icon, and action should be shown.
///
/// The parent is fully responsible for the title, message, icon, and
/// optional action. This keeps the widget reusable across any empty-state
/// scenario without encoding feature-specific assumptions.
class EmptyCoursesWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const EmptyCoursesWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.menu_book_outlined,
                size: 40,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}