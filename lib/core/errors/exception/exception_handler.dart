import 'package:task_dashboard/core/errors/errors.dart';
import 'package:task_dashboard/core/errors/errors_handler.dart';
import 'exceptions.dart' hide GSerializationError;
import '../failures/failures.dart';

class GExceptionHandler {
  static GFailure exceptionToFailure(GException error) {
    return _convertAppExceptionToFailure(error);
  }

  static GFailure appExceptionHandler(dynamic exception) {
    try {
      if (exception is GException) {
        return _convertAppExceptionToFailure(exception);
      }
      // Assuming convertErrorsToFailures takes GError, need to convert Exception to GError first?
      // task code had: return GErrorsHandler.convertErrorsToFailures(exception);
      // But convertErrorsToFailures takes GError.
      // And appExceptionHandler takes dynamic exception.
      // If exception is not GException, it might be Exception.
      // GErrorsHandler.handleError(exception) returns GError.
      // So:
      final gError = GErrorsHandler.handleError(
        exception is Exception ? exception : Exception(exception.toString()),
      );
      return GErrorsHandler.convertErrorsToFailures(gError);
    } catch (e) {
      return GUnknownFailure(message: e.toString());
    }
  }

  static GFailure _convertAppExceptionToFailure(GException exception) {
    if (exception is GNetworkException) {
      return GNetworkFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError ?? exception,
      );
    }

    //  used for server error
    if (exception is GServerException) {
      final status = exception.code ?? 500;
      return GServerFailure.fromStatusCode(
        statusCode: status,
        message: exception.message,
        originalError: exception.originalError ?? exception,
      );
    }

    if (exception is GParsingException || exception is GSerializationError) {
      return GSerializationFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError ?? exception,
      );
    }

    if (exception is GUnauthorizedException) {
      return GServerFailure(
        statusCode: exception.code ?? 401,
        message: exception.message,
        originalError: exception.originalError ?? exception,
      );
    }

    if (exception is GCacheException) {
      return CacheFailure(
        message: exception.message,
        code: exception.code,
        originalError: exception.originalError ?? exception,
      );
    }

    // Fallback for any unclassified AppException
    return GUnknownFailure(
      message: exception.message,
      code: exception.code,
      originalError: exception.originalError ?? exception,
    );
  }
}
