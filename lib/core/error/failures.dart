/// Base failure class for error handling across the app.
///
/// All domain-level errors extend this class.
/// The presentation layer receives [Failure] objects, never raw exceptions.
abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

/// Failure from a remote server (Supabase, API, etc.)
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

/// Failure from local cache/storage operations
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Failure from authentication operations
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

/// Failure from network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Sem conexão com a internet'});
}

/// Generic unexpected failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = 'Ocorreu um erro inesperado'});
}

/// Failure for invalid user inputs (e.g. empty fields)
class InvalidInputFailure extends Failure {
  const InvalidInputFailure(String message) : super(message: message);
}
