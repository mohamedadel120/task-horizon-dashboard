import 'dart:convert' show JsonUnsupportedObjectError;

import 'package:task_dashboard/core/errors/errors.dart';
import 'package:task_dashboard/core/errors/exception/exceptions.dart'
    hide GSerializationError;
import 'package:task_dashboard/core/errors/failures/failures.dart';

class GErrorsHandler {
  static GFailure convertErrorsToFailures(GError error) {
    if (error is GValidationError) {
      return GValidationFailure(message: error.message, code: error.code);
    } else if (error is GCacheError) {
      return CacheFailure(message: error.message);
    } else if (error is GApiParsingError) {
      return GSerializationFailure(message: error.message);
    } else if (error is GFormatError) {
      return GFormatFailure(
        message: error.message,
        offset: error.offset,
        source: error.source,
      );
    }

    return GUnknownFailure(
      message: error.message,
      code: error.code,
      originalError: error.originalError,
    );
  }

  static GError handleError(Exception error) {
    return _handleStandardExceptionError(error);
  }

  static GError _handleStandardExceptionError(dynamic error) {
    if (error is GFormatException) {
      return GFormatError(
        offset: error.offset,
        source: error.source,
        message: error.message,
        originalError: error,
      );
    }

    if (error is GTimeoutException) {
      return GTimeoutError(
        message: error.message,
        duration: error.duration,
        originalError: error.originalError,
      );
    }

    if (error is ArgumentError) {
      return GArgumentGError(
        name: error.name,
        invalidValue: error.invalidValue,
        stackTrace: error.stackTrace,
        message: error.message ?? '',
        originalError: error,
      );
    }

    if (error is RangeError) {
      return GRangeError(
        message: error.message ?? '',
        name: error.name,
        end: error.end,
        start: error.start,
      );
    }

    if (error is StateError) {
      return GStateGError(
        message: 'State error: ${error.message}',
        originalError: error.stackTrace,
      );
    }
    if (error is JsonUnsupportedObjectError) {
      return GSerializationError(
        message: error.stackTrace.toString(),
        unsupportedObject: error.unsupportedObject,
        partialResult: error.partialResult,
      );
    }

    return GUnknownError(
      message: error.message ?? '',
      originalError: error.originalError,
    );
  }
}
