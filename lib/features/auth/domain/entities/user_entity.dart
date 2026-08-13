import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String currentClass;
  final String dreamCareer;
  final String preferredLanguage;
  final DateTime? classChangeLockedUntil;
  final int studyStreak;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.currentClass,
    required this.dreamCareer,
    required this.preferredLanguage,
    this.classChangeLockedUntil,
    this.studyStreak = 0,
  });

  bool get isClassChangeLocked {
    final lockedUntil = classChangeLockedUntil;

    if (lockedUntil == null) {
      return false;
    }

    return DateTime.now().isBefore(lockedUntil);
  }

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? currentClass,
    String? dreamCareer,
    String? preferredLanguage,
    Object? classChangeLockedUntil = _unset,
    int? studyStreak,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      currentClass: currentClass ?? this.currentClass,
      dreamCareer: dreamCareer ?? this.dreamCareer,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      classChangeLockedUntil:
          identical(classChangeLockedUntil, _unset)
              ? this.classChangeLockedUntil
              : classChangeLockedUntil as DateTime?,
      studyStreak: studyStreak ?? this.studyStreak,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        currentClass,
        dreamCareer,
        preferredLanguage,
        classChangeLockedUntil,
        studyStreak,
      ];
}

const Object _unset = Object();
