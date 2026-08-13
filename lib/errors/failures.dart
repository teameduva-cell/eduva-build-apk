/// Base class for all failures in EDUVA.
///
/// Every repository/service should return a Failure
/// instead of throwing raw exceptions.
abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// Represents network-related failures.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No Internet Connection',
  ]);
}

/// Represents server/API failures.
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Something went wrong on the server.',
  ]);
}

/// Represents local storage/cache failures.
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Unable to read local data.',
  ]);
}