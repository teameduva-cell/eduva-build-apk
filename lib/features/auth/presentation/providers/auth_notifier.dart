import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_providers.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

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

  const AuthState.authenticated(UserEntity user)
      : status = AuthStatus.authenticated,
        user = user,
        failure = null;

  const AuthState.unauthenticated()
      : status = AuthStatus.unauthenticated,
        user = null,
        failure = null;

  const AuthState.error(Failure failure)
      : status = AuthStatus.error,
        user = null,
        failure = failure;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AuthState.initial()) {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    state = const AuthState.loading();

    final result = await ref.read(getCurrentUserProvider)();

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (user) {
        if (user == null) {
          state = const AuthState.unauthenticated();
        } else {
          state = AuthState.authenticated(user);
        }
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();

    final result = await ref.read(signInProvider)(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (user) {
        state = AuthState.authenticated(user);
      },
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String currentClass,
    required String dreamCareer,
    required String preferredLanguage,
  }) async {
    state = const AuthState.loading();

    final result = await ref.read(signUpProvider)(
      name: name,
      email: email,
      password: password,
      currentClass: currentClass,
      dreamCareer: dreamCareer,
      preferredLanguage: preferredLanguage,
    );

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (user) {
        state = AuthState.authenticated(user);
      },
    );
  }

  Future<void> signOut() async {
    state = const AuthState.loading();

    final result = await ref.read(signOutProvider)();

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (_) {
        state = const AuthState.unauthenticated();
      },
    );
  }

  Future<void> updateStudentClass({
    required String userId,
    required String newClass,
  }) async {
    final currentUser = state.user;

    if (currentUser == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    state = AuthState.loading();

    final result = await ref.read(updateStudentClassProvider)(
      userId: userId,
      newClass: newClass,
    );

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (updatedUser) {
        state = AuthState.authenticated(updatedUser);
      },
    );
  }

  Future<void> updateUserProfile(UserEntity user) async {
    if (state.user == null) {
      state = const AuthState.unauthenticated();
      return;
    }

    state = AuthState.loading();

    final result = await ref.read(updateUserProfileProvider)(user);

    result.fold(
      (failure) {
        state = AuthState.error(failure);
      },
      (updatedUser) {
        state = AuthState.authenticated(updatedUser);
      },
    );
  }

  void clearError() {
    final currentUser = state.user;

    if (currentUser != null) {
      state = AuthState.authenticated(currentUser);
    } else {
      state = const AuthState.unauthenticated();
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});