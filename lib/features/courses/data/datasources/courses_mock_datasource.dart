import '../models/course_model.dart';

/// Provides mock course data for the Courses feature.
///
/// This stands in for a real data source (REST API client or Firestore
/// datasource) so the repository implementation and presentation layer can
/// be built and demoed against realistic data now. When a real backend is
/// integrated, a new datasource (e.g. `CoursesRemoteDataSource`) will be
/// created implementing the same shape, and `CoursesRepositoryImpl` will
/// swap to it — no domain or presentation code will need to change.
class CoursesMockDataSource {
  const CoursesMockDataSource();

  /// Returns the full catalog of mock courses.
  Future<List<CourseModel>> getAllCourses() async {
    return _courses;
  }

  static final List<CourseModel> _courses = [
    const CourseModel(
      id: 'c1',
      title: 'Algebra Fundamentals',
      instructorName: 'Dr. Sarah Lin',
      category: 'Mathematics',
      description:
          'A complete introduction to algebraic expressions, equations, '
          'and functions, designed for students building a strong '
          'foundation in mathematics.',
      thumbnail: 'assets/images/courses/algebra_fundamentals.png',
      lessonCount: 12,
      rating: 4.7,
      enrolledStudents: 3420,
    ),
    const CourseModel(
      id: 'c2',
      title: 'Intro to Physics',
      instructorName: 'Prof. Ahmed Karim',
      category: 'Science',
      description:
          'Explore the fundamental laws of motion, energy, and matter '
          'through clear explanations and real-world examples.',
      thumbnail: 'assets/images/courses/intro_physics.png',
      lessonCount: 9,
      rating: 4.5,
      enrolledStudents: 2810,
    ),
    const CourseModel(
      id: 'c3',
      title: 'World History: Modern Era',
      instructorName: 'Dr. Elena Petrova',
      category: 'History',
      description:
          'Trace the major events, movements, and figures that shaped the '
          'modern world, from industrialization to globalization.',
      thumbnail: 'assets/images/courses/world_history_modern.png',
      lessonCount: 15,
      rating: 4.8,
      enrolledStudents: 1975,
    ),
    const CourseModel(
      id: 'c4',
      title: 'Python for Beginners',
      instructorName: 'James Okafor',
      category: 'Programming',
      description:
          'Learn Python from scratch — variables, control flow, functions, '
          'and hands-on projects to build real programming confidence.',
      thumbnail: 'assets/images/courses/python_beginners.png',
      lessonCount: 20,
      rating: 4.9,
      enrolledStudents: 5230,
    ),
    const CourseModel(
      id: 'c5',
      title: 'Creative Writing Basics',
      instructorName: 'Maria Gonzalez',
      category: 'Languages',
      description:
          'Develop your voice as a writer through guided exercises in '
          'narrative, character, and descriptive language.',
      thumbnail: 'assets/images/courses/creative_writing_basics.png',
      lessonCount: 18,
      rating: 4.6,
      enrolledStudents: 1420,
      progress: 0.45,
    ),
    const CourseModel(
      id: 'c6',
      title: 'Introduction to Chemistry',
      instructorName: 'Dr. Priya Nair',
      category: 'Science',
      description:
          'Understand the building blocks of matter, chemical reactions, '
          'and the periodic table through clear, structured lessons.',
      thumbnail: 'assets/images/courses/intro_chemistry.png',
      lessonCount: 14,
      rating: 4.4,
      enrolledStudents: 2190,
    ),
    const CourseModel(
      id: 'c7',
      title: 'Digital Art Fundamentals',
      instructorName: 'Noah Bennett',
      category: 'Art',
      description:
          'Master the basics of digital illustration, color theory, and '
          'composition using industry-standard techniques.',
      thumbnail: 'assets/images/courses/digital_art_fundamentals.png',
      lessonCount: 11,
      rating: 4.7,
      enrolledStudents: 980,
    ),
    const CourseModel(
      id: 'c8',
      title: 'Spanish for Beginners',
      instructorName: 'Isabel Torres',
      category: 'Languages',
      description:
          'Start speaking Spanish with confidence through practical '
          'vocabulary, grammar, and everyday conversation practice.',
      thumbnail: 'assets/images/courses/spanish_beginners.png',
      lessonCount: 16,
      rating: 4.8,
      enrolledStudents: 4110,
      progress: 0.2,
    ),
  ];
}