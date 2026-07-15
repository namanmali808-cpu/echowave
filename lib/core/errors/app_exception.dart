class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    this.statusCode,
    super.code,
    super.stackTrace,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.stackTrace,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache read/write failed',
    super.code = 'CACHE_ERROR',
    super.stackTrace,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission denied',
    super.code = 'PERMISSION_DENIED',
    super.stackTrace,
  });
}

class StreamException extends AppException {
  const StreamException({
    super.message = 'Failed to stream audio',
    super.code = 'STREAM_ERROR',
    super.stackTrace,
  });
}

class DownloadException extends AppException {
  const DownloadException({
    super.message = 'Failed to download content',
    super.code = 'DOWNLOAD_ERROR',
    super.stackTrace,
  });
}
