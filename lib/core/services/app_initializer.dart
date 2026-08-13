import 'app_version_service.dart';
import 'auth_service.dart';
import 'connectivity_service.dart';
import 'firebase_service.dart';

/// Stores the result of app initialization.
class AppInitializationResult {
  final bool isLoggedIn;
  final bool hasConnection;
  final bool updateRequired;

  const AppInitializationResult({
    required this.isLoggedIn,
    required this.hasConnection,
    required this.updateRequired,
  });
}

/// Initializes all startup services required by EDUVA.
class AppInitializer {
  final FirebaseService _firebaseService;
  final AuthService _authService;
  final ConnectivityService _connectivityService;
  final AppVersionService _appVersionService;

  const AppInitializer({
    FirebaseService firebaseService = const FirebaseService(),
    AuthService authService = const AuthService(),
    ConnectivityService connectivityService =
        const ConnectivityService(),
    AppVersionService appVersionService =
        const AppVersionService(),
  })  : _firebaseService = firebaseService,
        _authService = authService,
        _connectivityService = connectivityService,
        _appVersionService = appVersionService;

  /// Runs all startup checks.
  Future<AppInitializationResult> initialize() async {
    await _firebaseService.initialize();

    final hasConnection =
        await _connectivityService.hasConnection();

    final updateRequired =
        await _appVersionService.isUpdateRequired();

    final isLoggedIn =
        await _authService.isLoggedIn();

    return AppInitializationResult(
      isLoggedIn: isLoggedIn,
      hasConnection: hasConnection,
      updateRequired: updateRequired,
    );
  }
}