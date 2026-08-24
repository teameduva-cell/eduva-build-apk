import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_providers.dart';
import '../../../../errors/failures.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final Failure? failure;

  const AuthState({
    required this.status,
    this.user,
    this.failure,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        failure = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        failure = null;

  const AuthState.authenticated(this.user)
      : status = AuthStatus.authenticated,
        failure = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        failure = null;

  const AuthState.error(this.failure)
      : status = AuthStatus.error,
        user = null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState.unauthenticated()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    try {
      final getCurrentUser = ref.read(getCurrentUserProvider);
      final result = await getCurrentUser().timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('Auth check timed out'),
      );
      result.fold(
        (failure) => state = const AuthState.unauthenticated(),
        (user) {
          if (user != null) {
            state = AuthState.authenticated(user);
          } else {
            state = const AuthState.unauthenticated();
          }
        },
      );
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final signInUseCase = ref.read(signInProvider);
      final result = await signInUseCase(email: email, password: password).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Sign in timed out. Check connection.'),
      );
      result.fold(
        (failure) => state = AuthState.error(failure),
        (user) => state = AuthState.authenticated(user),
      );
    } catch (e) {
      state = AuthState.error(ServerFailure(e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String studentClass,
    required String dreamCareer,
    required String preferredLanguage,
  }) async {
    state = const AuthState.loading();
    try {
      final signUpUseCase = ref.read(signUpProvider);
      final result = await signUpUseCase(
        name: name,
        email: email,
        password: password,
        studentClass: studentClass,
        dreamCareer: dreamCareer,
        preferredLanguage: preferredLanguage,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('Sign up timed out.'),
      );
      result.fold(
        (failure) => state = AuthState.error(failure),
        (user) => state = AuthState.authenticated(user),
      );
    } catch (e) {
      state = AuthState.error(ServerFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    state = const AuthState.loading();
    final signOutUseCase = ref.read(signOutProvider);
    await signOutUseCase();
    state = const AuthState.unauthenticated();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
