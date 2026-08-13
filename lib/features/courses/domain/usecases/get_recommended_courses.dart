import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

/// Use case: retrieves courses recommended for the current student.
///
/// Wraps a single [CoursesRepository] method as its own class so the
/// presentation layer depends on a focused, single-purpose use case rather
/// than the entire repository surface — this follows the Single
/// Responsibility Principle and keeps presentation-layer code easy to test
/// with a mocked use case instead of a mocked repository.
///
/// The repository is injected via the constructor (Dependency Inversion),
/// so this use case never knows or cares how recommendations are computed
/// (enrollment history, category interests, trending content, etc.) or
/// where that logic lives — that decision belongs entirely to the data
/// layer's repository implementation.
class GetRecommendedCourses {
  final CoursesRepository _repository;

  const GetRecommendedCourses(this._repository);

  /// Executes the use case.
  Future<List<CourseEntity>> call() {
    return _repository.getRecommendedCourses();
  }
}