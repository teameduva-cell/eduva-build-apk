import 'package:dartz/dartz.dart';

import '../../../../errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserProfile {
  final AuthRepository repository;

  const UpdateUserProfile(this.repository);

  Future<Either<Failure, UserEntity>> call(UserEntity user) {
    return repository.updateUserProfile(user);
  }
}