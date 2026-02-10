// Base class for all server failures

part of 'failures.dart';

class GServerFailure extends GFailure {
  final int statusCode;

  GServerFailure({
    required this.statusCode,
    required super.message,
    dynamic super.originalError,
  }) : super(code: statusCode);

  /// Factory method to create appropriate ServerFailure from status code
  factory GServerFailure.fromStatusCode({
    required int statusCode,
    String? message,
    dynamic originalError,
  }) {
    return switch (statusCode) {
      ApiStatusCode.BAD_REQUEST => GBadRequestFailure(
        message: message,
        originalError: originalError,
      ),
      ApiStatusCode.UNAUTHORIZED => GUnauthorizedFailure(
        message: message,
        originalError: originalError,
      ),
      ApiStatusCode.FORBIDDEN => GForbiddenFailure(
        message: message,
        originalError: originalError,
      ),
      ApiStatusCode.NOT_FOUND => GNotFoundFailure(
        message: message,
        originalError: originalError,
      ),
      ApiStatusCode.NO_CONTENT => GNoContentFailure(
        message: message,
        originalError: originalError,
      ),
      ApiStatusCode.API_LOGIC_ERROR => GServerValidationFailure(
        message: message,
        originalError: originalError,
      ),
      >= 500 && < 600 => GInternalServerErrorFailure(
        message: message,
        originalError: originalError,
      ),
      _ => GenericServerFailure(
        statusCode: statusCode,
        message: message,
        originalError: originalError,
      ),
    };
  }
}

// Specific server failure classes
class GBadRequestFailure extends GServerFailure {
  GBadRequestFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.BAD_REQUEST,
        message: message ?? 'Bad request error',
      );
}

class GUnauthorizedFailure extends GServerFailure {
  GUnauthorizedFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.UNAUTHORIZED,
        message: message ?? 'Unauthorized access',
      );
}

class GForbiddenFailure extends GServerFailure {
  GForbiddenFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.FORBIDDEN,
        message: message ?? 'Access forbidden',
      );
}

class GNotFoundFailure extends GServerFailure {
  GNotFoundFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.NOT_FOUND,
        message: message ?? 'Resource not found',
      );
}

class GNoContentFailure extends GServerFailure {
  GNoContentFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.NO_CONTENT,
        message: message ?? 'No content available',
      );
}

class GInternalServerErrorFailure extends GServerFailure {
  GInternalServerErrorFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.INTERNAL_SERVER_ERROR,
        message: message ?? 'Internal server error',
      );
}

class GServerValidationFailure extends GServerFailure {
  GServerValidationFailure({String? message, super.originalError})
    : super(
        statusCode: ApiStatusCode.API_LOGIC_ERROR,
        message: message ?? 'Validation error',
      );
}

class GenericServerFailure extends GServerFailure {
  GenericServerFailure({
    required super.statusCode,
    String? message,
    super.originalError,
  }) : super(message: message ?? 'Server error occurred');
}

