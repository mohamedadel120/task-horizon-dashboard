abstract class GError {
  final String message;
  final int? code;
  final dynamic originalError;

  GError({required this.message, this.code, this.originalError});
}

class GValidationError extends GError {
  GValidationError({required super.message, super.originalError});
}

class GCacheError extends GError {
  GCacheError({required super.message, super.originalError});
}

class GApiParsingError extends GError {
  GApiParsingError({required super.message, super.originalError});
}

class GFormatError extends GError {
  final dynamic source;
  final int? offset;

  GFormatError({
    required super.message,
    super.originalError,
    this.offset,
    this.source,
  });
}

class GSerializationError extends GError {
  /// The object that could not be serialized.
  final Object? unsupportedObject;
  final String? partialResult;

  GSerializationError({
    required super.message,
    this.unsupportedObject,
    this.partialResult,
    super.originalError,
  });
}

class GArgumentGError extends GError {
  final String? name;
  final StackTrace? stackTrace;
  final dynamic invalidValue;

  GArgumentGError({
    required this.name,
    this.stackTrace,
    this.invalidValue,
    required super.message,
    super.originalError,
  });
}

class GStateGError extends GError {
  GStateGError({required super.message, super.code, super.originalError});
}

/// Thrown when [GoRouter] is used incorrectly.
class GGoError extends GError {
  GGoError({required super.message, super.originalError});
}

class GTimeoutError extends GError {
  final Duration? duration;

  GTimeoutError({required super.message, this.duration, super.originalError});
}

class GRangeError extends GError {
  final num? start;
  final num? end;
  final String? name;

  GRangeError({
    required super.message,
    required this.end,
    required this.start,
    this.name,
  });
}

class GUnknownError extends GError {
  GUnknownError({required super.message, super.originalError});
}

