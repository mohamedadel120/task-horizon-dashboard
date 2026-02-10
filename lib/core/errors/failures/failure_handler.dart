/// Handles conversion of DioException to appropriate Failure types.
library;

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'failures.dart';

class FailureHandler {
  /// Converts DioException to appropriate Failure
  static GFailure handleDioFailure(DioException exception) {
    final statusCode = exception.response?.statusCode;
    // Get response data - this is the actual JSON response body
    final responseData = exception.response?.data;

    log('handleDioFailure - responseData type: ${responseData.runtimeType}');
    log('handleDioFailure - responseData: $responseData');
    log('handleDioFailure - exception.message: ${exception.message}');

    // Extract error message from response data, not from exception.message
    final errorMessage = _extractErrorMessage(exception, responseData);
    log('handleDioFailure - extracted errorMessage: $errorMessage');
    return _createFailureFromDioException(exception, errorMessage, statusCode);
  }

  static GFailure _createFailureFromDioException(
    DioException exception,
    String errorMessage,
    int? statusCode,
  ) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => GConnectionTimeout(
        message: errorMessage,
        code: statusCode,
        originalError: exception,
      ),

      DioExceptionType.sendTimeout => GSendTimeoutFailure(
        message: errorMessage,
        code: statusCode,
        originalError: exception,
      ),

      DioExceptionType.receiveTimeout => GReceiveTimeoutFailure(
        message: exception.message,
        code: statusCode,
        originalError: exception,
      ),

      DioExceptionType.cancel => GRequestCancelledFailure(
        message: errorMessage,
        code: statusCode,
        originalError: exception,
      ),

      DioExceptionType.badResponse => GServerFailure.fromStatusCode(
        statusCode: statusCode ?? 500,
        message: errorMessage,
        originalError: exception,
      ),

      DioExceptionType.connectionError => GNetworkFailure(
        code: statusCode,
        originalError: exception,
      ),

      DioExceptionType.unknown => _handleUnknownDioException(
        exception,
        errorMessage,
        statusCode,
      ),

      DioExceptionType.badCertificate => GUnknownFailure(
        code: statusCode ?? 500,
        originalError: exception,
      ),
    };
  }

  /// Handles unknown DioException types
  static GFailure _handleUnknownDioException(
    DioException exception,
    String message,
    int? statusCode,
  ) {
    if (exception.error is SocketException) {
      return GNetworkFailure(
        message: message.isNotEmpty ? message : 'No internet connection',
        code: statusCode,
        originalError: exception,
      );
    }

    return GUnknownFailure(
      message: message.isNotEmpty ? message : 'Unknown network error',
      code: statusCode,
      originalError: exception,
    );
  }

  static String _extractErrorMessage(
    DioException exception,
    dynamic responseData,
  ) {
    log('_extractErrorMessage - responseData: $responseData');
    log(
      '_extractErrorMessage - responseData type: ${responseData.runtimeType}',
    );

    // ONLY use responseData, NEVER use exception.message for API errors
    if (responseData != null) {
      // Handle Map response (JSON object)
      if (responseData is Map<String, dynamic>) {
        log('_extractErrorMessage - responseData is Map');
        // First try to get message from responseData['message']
        final message = responseData['message'] as String?;
        log('_extractErrorMessage - message from responseData: $message');
        if (message != null && message.isNotEmpty) {
          log('Extracted error message from responseData: $message');
          return message;
        }

        // If no message, try to get from errors object
        final errors = responseData['errors'] as Map<String, dynamic>?;
        log('_extractErrorMessage - errors: $errors');
        if (errors != null && errors.isNotEmpty) {
          // Get first error from first field
          final firstErrorKey = errors.keys.first;
          final firstErrorValue = errors[firstErrorKey];
          if (firstErrorValue is List && firstErrorValue.isNotEmpty) {
            final errorMsg = firstErrorValue[0] as String? ?? '';
            log('Extracted error message from errors object: $errorMsg');
            return errorMsg;
          } else if (firstErrorValue is String) {
            log('Extracted error message from errors object: $firstErrorValue');
            return firstErrorValue;
          }
        }

        // Fallback to error field in responseData
        final error = responseData['error'] as String?;
        if (error != null && error.isNotEmpty) {
          log('Extracted error message from error field: $error');
          return error;
        }
      }

      // Handle String response
      if (responseData is String && responseData.isNotEmpty) {
        log('Extracted error message from String response: $responseData');
        return responseData;
      }

      log(
        '_extractErrorMessage - responseData is not Map or String, type: ${responseData.runtimeType}',
      );
    } else {
      log('_extractErrorMessage - responseData is null');
    }

    // If no responseData, return generic error (never use exception.message for API errors)
    log('_extractErrorMessage - returning generic error message');
    return 'Network error occurred';
  }
}

