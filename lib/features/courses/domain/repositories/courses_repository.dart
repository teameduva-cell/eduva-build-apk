import '../entities/course_entity.dart';

/// Defines the contract for retrieving course data, independent of how or
/// where that data actually comes from (REST API, Firestore, local cache,
/// mock data, etc.).
///
/// Per the Dependency Inversion Principle, the domain layer depends only on
/// this abstraction. Use cases in this feature will depend on
/// [CoursesRepository], never on a concrete implementation — the concrete
/// class (e.g. `CoursesRepositoryImpl`) will live in the data layer and be
/// injected wherever this contract is required. This keeps the domain layer
/// fully testable via mocks and free of any framework/networking concerns.
abstract class CoursesRepository {
  /// Retrieves the full list of available courses.
  Future<List<CourseEntity>> getAllCourses();

  /// Retrieves courses belonging to a specific [category].
  Future<List<CourseEntity>> getCoursesByCategory(String category);

  /// Retrieves a single course by its [id].
  ///
  /// Returns null if no course with the given [id] exists.
  Future<CourseEntity?> getCourseById(String id);

  /// Retrieves the list of courses the student is currently enrolled in
  /// (i.e. courses with non-null progress).
  Future<List<CourseEntity>> getEnrolledCourses();

  /// Searches courses by [query], matching against title, instructor,
  /// or category.
  Future<List<CourseEntity>> searchCourses(String query);

  /// Retrieves courses recommended for the current student
  /// (e.g. based on enrollment history, category interests, or trending
  /// content — the exact recommendation logic belongs to the data layer).
  Future<List<CourseEntity>> getRecommendedCourses();
}