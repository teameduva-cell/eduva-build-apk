/// Represents a full course within the Courses feature (catalog/detail view).
///
/// This is intentionally a richer model than dashboard's `CourseEntity` —
/// it carries everything a course listing/detail screen needs. Kept as a
/// pure Dart class (no Flutter imports) per Clean Architecture: the domain
/// layer must remain independent of the UI framework and any data source.
class CourseEntity {
  final String id;
  final String title;
  final String instructorName;
  final String category;
  final String description;
  final String thumbnail;
  final int lessonCount;
  final double rating;
  final int enrolledStudents;
  final double? progress;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.instructorName,
    required this.category,
    required this.description,
    required this.thumbnail,
    required this.lessonCount,
    required this.rating,
    required this.enrolledStudents,
    this.progress,
  });
}