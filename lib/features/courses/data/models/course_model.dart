import '../../domain/entities/course_entity.dart';

/// Data-layer representation of a course.
///
/// Extends [CourseEntity] rather than duplicating its fields — this is the
/// standard Clean Architecture pattern for models: the domain entity stays
/// the single source of truth for the shape of a course, while this model
/// adds data-layer-only concerns (serialization to/from Map, which will
/// back JSON/Firestore parsing once a real data source is introduced).
///
/// Widgets and use cases never depend on [CourseModel] directly — they only
/// ever see [CourseEntity]. This model is confined to the data layer
/// (datasources and repository implementations).
class CourseModel extends CourseEntity {
  const CourseModel({
    required super.id,
    required super.title,
    required super.instructorName,
    required super.category,
    required super.description,
    required super.thumbnail,
    required super.lessonCount,
    required super.rating,
    required super.enrolledStudents,
    super.progress,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      instructorName: map['instructorName'] as String,
      category: map['category'] as String,
      description: map['description'] as String,
      thumbnail: map['thumbnail'] as String,
      lessonCount: map['lessonCount'] as int,
      rating: (map['rating'] as num).toDouble(),
      enrolledStudents: map['enrolledStudents'] as int,
      progress: map['progress'] != null
          ? (map['progress'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'instructorName': instructorName,
      'category': category,
      'description': description,
      'thumbnail': thumbnail,
      'lessonCount': lessonCount,
      'rating': rating,
      'enrolledStudents': enrolledStudents,
      'progress': progress,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? instructorName,
    String? category,
    String? description,
    String? thumbnail,
    int? lessonCount,
    double? rating,
    int? enrolledStudents,
    double? progress,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      instructorName: instructorName ?? this.instructorName,
      category: category ?? this.category,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      lessonCount: lessonCount ?? this.lessonCount,
      rating: rating ?? this.rating,
      enrolledStudents: enrolledStudents ?? this.enrolledStudents,
      progress: progress ?? this.progress,
    );
  }

  factory CourseModel.fromEntity(CourseEntity entity) {
    return CourseModel(
      id: entity.id,
      title: entity.title,
      instructorName: entity.instructorName,
      category: entity.category,
      description: entity.description,
      thumbnail: entity.thumbnail,
      lessonCount: entity.lessonCount,
      rating: entity.rating,
      enrolledStudents: entity.enrolledStudents,
      progress: entity.progress,
    );
  }

  CourseEntity toEntity() {
    return CourseEntity(
      id: id,
      title: title,
      instructorName: instructorName,
      category: category,
      description: description,
      thumbnail: thumbnail,
      lessonCount: lessonCount,
      rating: rating,
      enrolledStudents: enrolledStudents,
      progress: progress,
    );
  }
}