import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../../../errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        return const Right(null);
      }

      final snapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!snapshot.exists || snapshot.data() == null) {
        return const Left(
          ServerFailure('User profile not found in database.'),
        );
      }

      return Right(
        UserModel.fromMap(snapshot.data()!, firebaseUser.uid),
      );
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Unable to load user profile.',
        ),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Unable to load user profile. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return const Left(
        ServerFailure('Email and password are required.'),
      );
    }

    try {
      final credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return const Left(
          ServerFailure('Sign in failed. Please try again.'),
        );
      }

      final snapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      if (!snapshot.exists || snapshot.data() == null) {
        return const Left(
          ServerFailure('User profile not found.'),
        );
      }

      return Right(
        UserModel.fromMap(snapshot.data()!, firebaseUser.uid),
      );
    } on auth.FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(_authErrorMessage(e.code)),
      );
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Unable to sign in. Please try again.',
        ),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Unable to sign in. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String name,
    required String email,
    required String password,
    required String currentClass,
    required String dreamCareer,
    required String preferredLanguage,
  }) async {
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty ||
        currentClass.trim().isEmpty ||
        dreamCareer.trim().isEmpty ||
        preferredLanguage.trim().isEmpty) {
      return const Left(
        ServerFailure('Please complete all required fields.'),
      );
    }

    try {
      final credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return const Left(
          ServerFailure('Sign up failed. Please try again.'),
        );
      }

      final userModel = UserModel(
        id: firebaseUser.uid,
        name: name.trim(),
        email: email.trim(),
        currentClass: currentClass.trim(),
        dreamCareer: dreamCareer.trim(),
        preferredLanguage: preferredLanguage.trim(),
        classChangeLockedUntil: null,
        studyStreak: 0,
      );

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set(userModel.toMap());

      return Right(userModel);
    } on auth.FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(_authErrorMessage(e.code)),
      );
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Unable to create your account.',
        ),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Unable to create your account. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } on auth.FirebaseAuthException catch (e) {
      return Left(
        ServerFailure(_authErrorMessage(e.code)),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Unable to sign out. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile(
    UserEntity user,
  ) async {
    if (user.id.trim().isEmpty) {
      return const Left(
        ServerFailure('Invalid user ID.'),
      );
    }

    try {
      final userModel = UserModel.fromEntity(user);

      await _firestore
          .collection('users')
          .doc(user.id)
          .update(userModel.toMap());

      return Right(userModel);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Unable to update your profile.',
        ),
      );
    } catch (_) {
      return const Left(
        ServerFailure('Unable to update your profile. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateStudentClass({
    required String userId,
    required String newClass,
  }) async {
    final trimmedUserId = userId.trim();
    final trimmedClass = newClass.trim();

    if (trimmedUserId.isEmpty) {
      return const Left(
        ServerFailure('Invalid user ID.'),
      );
    }

    if (trimmedClass.isEmpty) {
      return const Left(
        ServerFailure('Please select a valid class.'),
      );
    }

    try {
      final docRef =
          _firestore.collection('users').doc(trimmedUserId);

      final snapshot = await docRef.get();

      if (!snapshot.exists || snapshot.data() == null) {
        return const Left(
          ServerFailure('User profile not found.'),
        );
      }

      final currentUser =
          UserModel.fromMap(snapshot.data()!, trimmedUserId);

      if (currentUser.isClassChangeLocked) {
        return const Left(
          ServerFailure(
            'Class cannot be changed during the 15-day lock period. '
            'Please contact EDUVA support if you need an exception.',
          ),
        );
      }

      if (currentUser.currentClass == trimmedClass) {
        return Right(currentUser);
      }

      final lockUntil =
          DateTime.now().add(const Duration(days: 15));

      final updatedUser = currentUser.copyWith(
        currentClass: trimmedClass,
        classChangeLockedUntil: lockUntil,
      );

      final updatedModel = UserModel.fromEntity(updatedUser);

      await docRef.update(updatedModel.toMap());

      return Right(updatedModel);
    } on FirebaseException catch (e) {
      return Left(
        ServerFailure(
          e.message ?? 'Unable to change class. Please try again.',
        ),
      );
    } catch (_) {
      return const Left(
        ServerFailure(
          'Unable to change class. Please try again.',
        ),
      );
    }
  }

  String _authErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
        return 'No account was found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}