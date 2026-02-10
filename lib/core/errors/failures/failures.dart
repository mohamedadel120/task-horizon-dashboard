import 'package:task_dashboard/core/helpers/api_status_code.dart';

/// These classes represent different types of failures that can occur
part 'server_failure.dart';

abstract class GFailure {
  final String message;
  final int? code;
  final Object? originalError;
  GFailure({required this.message, this.code, this.originalError});
}

class GNetworkFailure extends GFailure {
  GNetworkFailure({
    super.message = 'Network error occurred',
    super.code,
    dynamic super.originalError,
  });
}

class GTimeoutFailure extends GFailure {
  GTimeoutFailure({String? message, super.code, dynamic super.originalError})
    : super(message: message ?? '');
}

class GRequestCancelledFailure extends GFailure {
  GRequestCancelledFailure({
    super.message = 'Request was cancelled',
    super.code,
    dynamic super.originalError,
  });
}

class ParsingFailure extends GFailure {
  ParsingFailure({
    super.message = 'Data parsing error',
    super.code,
    dynamic super.originalError,
  });
}

/// Represents cache operation failures
class CacheFailure extends GFailure {
  CacheFailure({
    super.message = 'Cache error occurred',
    super.code,
    dynamic super.originalError,
  });
}

/// Represents validation failures
class GValidationFailure extends GFailure {
  GValidationFailure({
    required super.message,
    super.code,
    dynamic super.originalError,
  });
}

/// Represents permission-related failures
class GPermissionFailure extends GFailure {
  GPermissionFailure({
    super.message = 'Permission denied',
    super.code,
    dynamic super.originalError,
  });
}

class GUnknownFailure extends GFailure {
  GUnknownFailure({
    super.message = 'An unknown error occurred',
    super.code,
    dynamic super.originalError,
  });
}

class GSerializationFailure extends GFailure {
  GSerializationFailure({
    super.message = 'An unknown error occurred',
    super.code,
    dynamic super.originalError,
  });
}

class GFormatFailure extends GFailure {
  final dynamic source;
  final int? offset;

  GFormatFailure({required super.message, this.offset, this.source});
}

class GReceiveTimeoutFailure extends GFailure {
  GReceiveTimeoutFailure({
    String? message,
    super.code,
    dynamic super.originalError,
  }) : super(message: message ?? '');
}

class GSendTimeoutFailure extends GFailure {
  GSendTimeoutFailure({
    String? message,
    super.code,
    dynamic super.originalError,
  }) : super(message: message ?? '');
}

class GConnectionTimeout extends GFailure {
  GConnectionTimeout({String? message, super.code, dynamic super.originalError})
    : super(message: message ?? 'Connection timeout');
}
