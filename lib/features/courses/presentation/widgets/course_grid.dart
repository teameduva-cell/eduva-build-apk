import 'package:flutter/material.dart';

import '../../domain/entities/course_entity.dart';
import 'course_card.dart';

/// A reusable, responsive grid of [CourseCard]s.
///
/// This widget is purely presentational — it has no knowledge of a
/// repository, datasource, use case, or state management solution. It
/// takes a plain list of [CourseEntity] and an optional tap callback,
/// forwarding taps for the tapped course to [onCourseTap].
///
/// Column count adapts to available width:
/// - < 600: 2 columns (phone)
/// - 600–899: 3 columns (tablet)
/// - >= 900: 4 columns (large screens)
class CourseGrid extends StatelessWidget {
  final List<CourseEntity> courses;
  final ValueChanged<CourseEntity>? onCourseTap;
  final EdgeInsetsGeometry? padding;

  const CourseGrid({
    super.key,
    required this.courses,
    this.onCourseTap,
    this.padding,
  });

  int _crossAxisCountFor(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount =
            _crossAxisCountFor(constraints.maxWidth);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: padding,
          itemCount: courses.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final course = courses[index];

            return CourseCard(
              course: course,
              onTap: onCourseTap == null
                  ? null
                  : () => onCourseTap!(course),
            );
          },
        );
      },
    );
  }
}