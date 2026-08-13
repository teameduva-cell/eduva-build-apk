import '../entities/course_entity.dart';
import '../repositories/courses_repository.dart';

/// Use case: searches courses matching a given query string.
///
/// Wraps a single [CoursesRepository] method as its own class so the
/// presentation layer depends on a focused, single-purpose use case rather
/// than the entire repository surface — this follows the Single
/// Responsibility Principle and keeps presentation-layer code easy to test
/// with a mocked use case instead of a mocked repository.
///
/// The repository is injected via the constructor (Dependency Inversion),
/// so this use case never knows or cares whether search is performed via
/// local filtering on mock data, a REST API query, or a Firestore query.
class SearchCourses {
  final CoursesRepository _repository;

  const SearchCourses(this._repository);

  /// Executes the use case for the given [query].
  ///
  /// Matches against title, instructor, or category, as defined by the
  /// [CoursesRepository] contract.
  Future<List<CourseEntity>> call(String query) {
    return _repository.searchCourses(query);
  }
}