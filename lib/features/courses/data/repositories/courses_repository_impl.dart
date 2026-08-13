import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/courses_repository.dart';
import '../datasources/courses_mock_datasource.dart';

/// Concrete implementation of [CoursesRepository], backed by
/// [CoursesMockDataSource].
///
/// This is the only place in the entire Courses feature that knows a mock
/// data source is being used — the domain layer depends solely on the
/// [CoursesRepository] abstraction, so swapping this for a real
/// implementation (backed by a remote API or Firestore datasource) later
/// requires touching only this file and its dependency injection wiring,
/// never any use case, entity, or widget.
///
/// The datasource is supplied via constructor injection rather than
/// instantiated internally, satisfying the Dependency Inversion Principle
/// and making this repository fully testable with a mocked datasource.
///
/// All methods convert [CourseModel] (data layer) into [CourseEntity]
/// (domain layer) via `model.toEntity()` before returning — [CourseModel]
/// never leaks past this class.
class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesMockDataSource _dataSource;

  const CoursesRepositoryImpl(this._dataSource);

  @override
  Future<List<CourseEntity>> getAllCourses() async {
    final models = await _dataSource.getAllCourses();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<CourseEntity?> getCourseById(String id) async {
    final models = await _dataSource.getAllCourses();
    final match = models.where((model) => model.id == id);
    return match.isEmpty ? null : match.first.toEntity();
  }

  @override
  Future<List<CourseEntity>> getCoursesByCategory(String category) async {
    final models = await _dataSource.getAllCourses();
    final normalizedCategory = category.trim().toLowerCase();

    return models
        .where((model) => model.category.toLowerCase() == normalizedCategory)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<CourseEntity>> getEnrolledCourses() async {
    final models = await _dataSource.getAllCourses();

    return models
        .where((model) => model.progress != null)
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<CourseEntity>> searchCourses(String query) async {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      return const [];
    }

    final models = await _dataSource.getAllCourses();

    return models
        .where(
          (model) =>
              model.title.toLowerCase().contains(normalizedQuery) ||
              model.instructorName
                  .toLowerCase()
                  .contains(normalizedQuery) ||
              model.category.toLowerCase().contains(normalizedQuery),
        )
        .map((model) => model.toEntity())
        .toList();
  }

  @override
  Future<List<CourseEntity>> getRecommendedCourses() async {
    final models = await _dataSource.getAllCourses();

    // Mock recommendation heuristic: highly rated courses the student
    // hasn't already enrolled in. Once a real backend exists, this method
    // will instead call a dedicated recommendations endpoint/algorithm —
    // callers won't notice the difference since the return shape is
    // unchanged.
    return models
        .where((model) => model.rating >= 4.6 && model.progress == null)
        .map((model) => model.toEntity())
        .toList();
  }
}