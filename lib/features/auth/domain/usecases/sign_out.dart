import 'package:dartz/dartz.dart';

import '../../../../errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignOut {
  final AuthRepository repository;

  const SignOut(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.signOut();
  }
}