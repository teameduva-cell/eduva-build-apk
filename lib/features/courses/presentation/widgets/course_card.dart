import 'package:flutter/material.dart';
import '../../domain/entities/course_entity.dart';
import 'category_tag.dart';
import 'rating_badge.dart';

/// A reusable card displaying a single course's summary information.
class CourseCard extends StatelessWidget {
  final CourseEntity course;
  final double? width;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: width,
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _CourseThumbnail(thumbnail: course.thumbnail),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CategoryTag(
                      label: course.category,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: RatingBadge(
                      rating: course.rating,
                      compact: true,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      course.instructorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_outlined,
                          size: 14,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.lessonCount} lessons',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                                        if (course.progress != null) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: course.progress,
                          minHeight: 6,
                          backgroundColor: colorScheme.primary.withOpacity(0.12),
                          valueColor: AlwaysStoppedAnimation(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${((course.progress ?? 0) * 100).round()}% complete',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders the course thumbnail with a fixed aspect ratio,
/// falling back to a placeholder if the image cannot be loaded.
class _CourseThumbnail extends StatelessWidget {
  final String thumbnail;

  const _CourseThumbnail({
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Image.asset(
        thumbnail,
        fit: BoxFit.cover,
        width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
          return Container(
            color: colorScheme.primary.withOpacity(0.1),
            alignment: Alignment.center,
            child: Icon(
              Icons.menu_book_rounded,
              color: colorScheme.primary,
              size: 32,
            ),
          );
        },
      ),
    );
  }
}