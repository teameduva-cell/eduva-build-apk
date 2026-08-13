import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

/// Use case: retrieves the list of courses the current student is
/// currently enrolled in (i.e. courses with progress underway).
///
/// Wraps a single [CoursesRepository] method as its own class so the
/// presentation layer depends on a focused, single-purpose use case rather
/// than the entire repository surface — this follows the Single
/// Responsibility Principle and keeps presentation-layer code easy to test
/// with a mocked use case instead of a mocked repository.
///
/// The repository is injected via the constructor (Dependency Inversion),
/// so this use case never knows or cares whether enrollment data comes
/// from mock data, a REST API, or Firestore.
class GetEnrolledCourses {
  final CoursesRepository _repository;

  const GetEnrolledCourses(this._repository);

  /// Executes the use case.
  Future<List<CourseEntity>> call() {
    return _repository.getEnrolledCourses();
  }
}