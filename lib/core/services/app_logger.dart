import 'dart:developer' as developer;

/// Centralized logging utility for EDUVA.
///
/// Avoid using print() directly.
/// All logs should go through AppLogger.
class AppLogger {
  AppLogger._();

  /// Logs informational messages.
  static void info(String message) {
    developer.log(
      message,
      name: 'EDUVA.INFO',
    );
  }

  /// Logs error messages.
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    developer.log(
      message,
      name: 'EDUVA.ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}