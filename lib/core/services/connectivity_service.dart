/// Checks internet connectivity for EDUVA.
///
/// This service is responsible only for checking
/// whether the device has an active internet connection.
///
/// Actual implementation using connectivity_plus
/// will be added later.
class ConnectivityService {
  const ConnectivityService();

  /// Returns true if internet connection is available.
  ///
  /// Placeholder implementation.
  Future<bool> hasConnection() async {
    // TODO: Integrate connectivity_plus package.
    await Future<void>.delayed(Duration.zero);

    return true;
  }
}