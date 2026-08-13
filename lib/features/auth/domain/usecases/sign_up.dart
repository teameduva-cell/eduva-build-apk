import 'package:dartz/dartz.dart';

import '../../../../errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository repository;

  const SignUp(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String name,
    required String email,
    required String password,
    required String currentClass,
    required String dreamCareer,
    required String preferredLanguage,
  }) {
    return repository.signUp(
      name: name,
      email: email,
      password: password,
      currentClass: currentClass,
      dreamCareer: dreamCareer,
      preferredLanguage: preferredLanguage,
    );
  }
}