import 'package:flutter/material.dart';

import '../../domain/entities/course_entity.dart';
import '../widgets/category_tag.dart';
import '../widgets/rating_badge.dart';

/// Displays complete information about a single course.
///
/// This screen is purely presentational: it receives a [CourseEntity]
/// directly through constructor injection and has no knowledge of any
/// repository, datasource, use case, or state management solution. The
/// caller is responsible for supplying the course.
class CourseDetailScreen extends StatelessWidget {
  final CourseEntity course;

  const CourseDetailScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              course.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 840,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CourseThumbnail(
                        thumbnail: course.thumbnail,
                      ),
                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          CategoryTag(
                            label: course.category,
                          ),
                          RatingBadge(
                            rating: course.rating,
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _CourseTitleAndInstructor(
                        course: course,
                      ),

                      const SizedBox(height: 20),

                      _CourseStatsRow(
                        course: course,
                      ),

                      const SizedBox(height: 28),

                      _CourseDescription(
                        description: course.description,
                      ),

                      const SizedBox(height: 28),

                      _CourseProgressSection(
                        course: course,
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
/// Renders the course's large header thumbnail with rounded corners,
/// falling back to a placeholder icon if the asset fails to load.
class _CourseThumbnail extends StatelessWidget {
  final String thumbnail;

  const _CourseThumbnail({
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          thumbnail,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              alignment: Alignment.center,
              color: colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.menu_book_rounded,
                size: 48,
                color: colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Displays the course title and instructor.
class _CourseTitleAndInstructor extends StatelessWidget {
  final CourseEntity course;

  const _CourseTitleAndInstructor({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          course.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'By ${course.instructorName}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}
/// A row of Material 3 stat cards summarizing lessons, enrolled students,
/// and rating.
class _CourseStatsRow extends StatelessWidget {
  final CourseEntity course;

  const _CourseStatsRow({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.menu_book_outlined,
            label: 'Lessons',
            value: '${course.lessonCount}',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.people_outline_rounded,
            label: 'Students',
            value: _formatCount(course.enrolledStudents),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.star_outline_rounded,
            label: 'Rating',
            value: course.rating.toStringAsFixed(1),
          ),
        ),
      ],
    );
  }

  /// Formats large enrollment counts compactly (e.g. 5230 -> "5.2k").
  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return '$count';
  }
}

/// A single stat tile rendered as a Material 3 surface card.
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: colorScheme.primary,
            size: 22,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the "About this course" section.
class _CourseDescription extends StatelessWidget {
  final String description;

  const _CourseDescription({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this course',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.75),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
/// Renders either:
/// - a progress bar, completion percentage, and "Continue Learning"
///   button (when [CourseEntity.progress] is non-null), or
/// - a "Start Learning" button (when the student hasn't enrolled yet).
///
/// This widget contains no business logic. Navigation and enrollment
/// actions will be connected later through use cases.
class _CourseProgressSection extends StatelessWidget {
  final CourseEntity course;

  const _CourseProgressSection({
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final progress = course.progress;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (progress == null) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          // TODO(eduva): Connect Start Learning use case.
          onPressed: () {},
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Start Learning',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor:
                colorScheme.primary.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${(progress * 100).round()}% completed',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            // TODO(eduva): Connect Continue Learning use case.
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Continue Learning',
            ),
          ),
        ),
      ],
    );
  }
}