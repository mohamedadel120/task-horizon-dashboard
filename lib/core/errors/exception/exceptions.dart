/// Application-specific exceptions that can be thrown during execution.
library;

class GException implements Exception {
  final String message;
  final int? code;
  final dynamic originalError;

  GException({required this.message, this.code, this.originalError});

  @override
  String toString() =>
      'AppException(message: $message, code: $code, originalError: $originalError)';
}

class GNetworkException extends GException {
  GNetworkException({
    super.message = 'Network error occurred',
    super.code,
    super.originalError,
  });
}

class GServerException extends GException {
  final int statusCode;

  GServerException({
    required this.statusCode,
    super.message = 'Server error occurred',
    int? code,
    super.originalError,
  }) : super(code: code ?? statusCode);
}

class GParsingException extends GException {
  GParsingException({
    super.message = 'Data parsing error',
    super.code,
    super.originalError,
  });
}

class GCacheException extends GException {
  GCacheException({required super.message, super.code, super.originalError});
}

class GUnauthorizedException extends GException {
  GUnauthorizedException({
    super.message = 'Unauthorized access',
    int? code,
    super.originalError,
  }) : super(code: code ?? 401);
}

class UnknownException extends GException {
  UnknownException({required super.message, super.code, super.originalError});
}

class GJsonDataException extends GException {
  GJsonDataException({required super.message});
}

class GProviderNotFoundException extends GException {
  GProviderNotFoundException({required super.message});
}

class GFormatException extends GException {
  final dynamic source;
  final int? offset;

  GFormatException({required super.message, this.offset, this.source});
}

class GTimeoutException extends GException {
  final Duration? duration;

  GTimeoutException({required super.message, this.duration});
}

class GSerializationError extends GException {
  GSerializationError({
    required super.message,
    super.code,
    super.originalError,
  });
}

