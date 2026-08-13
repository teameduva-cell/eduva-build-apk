import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_student_class.dart';
import '../../domain/usecases/update_user_profile.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

final signInProvider = Provider<SignIn>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignIn(repository);
});

final signUpProvider = Provider<SignUp>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUp(repository);
});

final signOutProvider = Provider<SignOut>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
});

final updateStudentClassProvider = Provider<UpdateStudentClass>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateStudentClass(repository);
});

final updateUserProfileProvider = Provider<UpdateUserProfile>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return UpdateUserProfile(repository);
});