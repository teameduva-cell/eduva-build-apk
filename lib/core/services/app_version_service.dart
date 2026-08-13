/// Checks whether the installed app version is supported.
///
/// This service will later be responsible for:
/// - Checking the current app version
/// - Comparing it with the latest version
/// - Supporting force update if required
class AppVersionService {
  const AppVersionService();

  /// Returns true if an app update is required.
  ///
  /// Placeholder implementation.
  Future<bool> isUpdateRequired() async {
    // TODO: Integrate package_info_plus and Remote Config.
    await Future<void>.delayed(Duration.zero);

    return false;
  }
}