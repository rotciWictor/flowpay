/// Infrastructure-level exceptions.
///
/// These are thrown by data sources and caught by repository implementations,
/// which convert them into domain-level [Failure] objects.
///
/// The domain and presentation layers NEVER see these exceptions directly.

class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(message: $message, statusCode: $statusCode)';
}

class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({required this.message, this.statusCode});

  @override
  String toString() => 'AuthException(message: $message, statusCode: $statusCode)';
}
