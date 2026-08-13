import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

/// Use case: retrieves a single course by its unique identifier.
///
/// Wraps a single [CoursesRepository] method as its own class so the
/// presentation layer depends on a focused, single-purpose use case rather
/// than the entire repository surface — this follows the Single
/// Responsibility Principle and keeps presentation-layer code easy to test
/// with a mocked use case instead of a mocked repository.
///
/// The repository is injected via the constructor (Dependency Inversion),
/// so this use case never knows or cares whether the course comes from mock
/// data, a REST API, or Firestore.
class GetCourseById {
  final CoursesRepository _repository;

  const GetCourseById(this._repository);

  /// Executes the use case for the given [id].
  ///
  /// Returns null if no course with the given [id] exists.
  Future<CourseEntity?> call(String id) {
    return _repository.getCourseById(id);
  }
}