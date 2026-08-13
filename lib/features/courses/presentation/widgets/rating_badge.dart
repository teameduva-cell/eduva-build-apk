import 'package:flutter/material.dart';

/// A reusable badge displaying a star icon alongside a numeric rating
/// (e.g. ⭐ 4.8).
///
/// Designed to be reusable across Course Cards, Dashboard,
/// Search results, Wishlist, and Course Details.
class RatingBadge extends StatelessWidget {
  final double rating;
  final bool compact;

  const RatingBadge({
    super.key,
    required this.rating,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final iconSize = compact ? 14.0 : 18.0;

    final textStyle = (compact
            ? theme.textTheme.labelSmall
            : theme.textTheme.labelLarge)
        ?.copyWith(
      color: colorScheme.onInverseSurface,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            color: Colors.amber,
            size: iconSize,
          ),
          SizedBox(width: compact ? 3 : 5),
          Text(
            rating.toStringAsFixed(1),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}