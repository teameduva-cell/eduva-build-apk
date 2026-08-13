/// Provides the current authentication state of the user.
///
/// This service is responsible only for authentication.
/// Actual authentication logic will be implemented later.
class AuthService {
  const AuthService();

  /// Returns whether the user is currently logged in.
  ///
  /// Placeholder implementation.
  Future<bool> isLoggedIn() async {
    // TODO: Replace with Firebase Auth or another auth provider.
    await Future<void>.delayed(Duration.zero);

    return false;
  }
}