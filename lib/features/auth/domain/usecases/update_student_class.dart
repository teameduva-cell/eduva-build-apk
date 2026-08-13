import 'package:dartz/dartz.dart';

import '../../../../errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateStudentClass {
  final AuthRepository repository;

  const UpdateStudentClass(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String userId,
    required String newClass,
  }) {
    return repository.updateStudentClass(
      userId: userId,
      newClass: newClass,
    );
  }
}