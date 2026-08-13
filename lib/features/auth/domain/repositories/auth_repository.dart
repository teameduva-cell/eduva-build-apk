import 'package:dartz/dartz.dart';

import '../../../../errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String currentClass,
    required String dreamCareer,
    required String preferredLanguage,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserEntity>> updateUserProfile(
    UserEntity user,
  );

  Future<Either<Failure, UserEntity>> updateStudentClass({
    required String userId,
    required String newClass,
  });
}