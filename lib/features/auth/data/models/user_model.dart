import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.currentClass,
    required super.dreamCareer,
    required super.preferredLanguage,
    super.classChangeLockedUntil,
    super.studyStreak,
  });

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      currentClass: entity.currentClass,
      dreamCareer: entity.dreamCareer,
      preferredLanguage: entity.preferredLanguage,
      classChangeLockedUntil: entity.classChangeLockedUntil,
      studyStreak: entity.studyStreak,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    final rawLockedUntil = map['classChangeLockedUntil'];

    DateTime? lockedUntil;

    if (rawLockedUntil is Timestamp) {
      lockedUntil = rawLockedUntil.toDate();
    } else if (rawLockedUntil is DateTime) {
      lockedUntil = rawLockedUntil;
    } else if (rawLockedUntil is String) {
      lockedUntil = DateTime.tryParse(rawLockedUntil);
    }

    final rawStudyStreak = map['studyStreak'];

    final studyStreak = rawStudyStreak is int
        ? rawStudyStreak
        : int.tryParse(rawStudyStreak?.toString() ?? '') ?? 0;

    return UserModel(
      id: id,
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      currentClass: map['currentClass']?.toString() ?? '',
      dreamCareer: map['dreamCareer']?.toString() ?? '',
      preferredLanguage:
          map['preferredLanguage']?.toString() ?? 'English',
      classChangeLockedUntil: lockedUntil,
      studyStreak: studyStreak,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'currentClass': currentClass,
      'dreamCareer': dreamCareer,
      'preferredLanguage': preferredLanguage,
      'classChangeLockedUntil': classChangeLockedUntil != null
          ? Timestamp.fromDate(classChangeLockedUntil!)
          : null,
      'studyStreak': studyStreak,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      currentClass: currentClass,
      dreamCareer: dreamCareer,
      preferredLanguage: preferredLanguage,
      classChangeLockedUntil: classChangeLockedUntil,
      studyStreak: studyStreak,
    );
  }
}