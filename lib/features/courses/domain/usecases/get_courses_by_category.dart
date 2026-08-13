import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

/// Use case: retrieves all courses belonging to a specific category.
///
/// Wraps a single [CoursesRepository] method as its own class so the
/// presentation layer depends on a focused, single-purpose use case rather
/// than the entire repository surface — this follows the Single
/// Responsibility Principle and keeps presentation-layer code easy to test
/// with a mocked use case instead of a mocked repository.
///
/// The repository is injected via the constructor (Dependency Inversion),
/// so this use case never knows or cares whether courses come from mock
/// data, a REST API, or Firestore.
class GetCoursesByCategory {
  final CoursesRepository _repository;

  const GetCoursesByCategory(this._repository);

  /// Executes the use case for the given [category].
  Future<List<CourseEntity>> call(String category) {
    return _repository.getCoursesByCategory(category);
  }
}