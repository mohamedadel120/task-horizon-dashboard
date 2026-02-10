/// High-level error handler that provides utilities for error handling throughout the app.
library;

import 'package:dio/dio.dart';
import 'package:task_dashboard/core/errors/errors.dart';
import 'package:task_dashboard/core/errors/errors_handler.dart';
import 'package:task_dashboard/core/errors/exception/exceptions.dart';
import '../errors/exception/exception_handler.dart';
import '../errors/failures/failure_handler.dart';
import '../errors/failures/failures.dart';

class GeneralHandler {
  static GFailure handleFailure(dynamic error) {
    try {
      if (error is DioException) {
        return handleDioError(error);
      } else if (error is GException) {
        return GExceptionHandler.exceptionToFailure(error);
      } else if (error is GServerException) {
        return GServerFailure.fromStatusCode(
          statusCode: error.statusCode,
          message: error.message,
          originalError: error.originalError,
        );
      } else if (error is GError)
        return GErrorsHandler.convertErrorsToFailures(error);
      return GUnknownFailure(message: error.toString());
    } catch (e) {
      return GExceptionHandler.exceptionToFailure(error);
    }
  }

  static GFailure handleDioError(DioException dioException) {
    return FailureHandler.handleDioFailure(dioException);
  }

  /// Handles application exceptions (for app errors)
  static GError handleGeneralErrors(Exception error) {
    return GErrorsHandler.handleError(error);
  }
}
