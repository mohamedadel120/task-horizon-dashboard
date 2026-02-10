import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task_dashboard/core/base/base_model.dart';
import 'package:task_dashboard/core/errors/failures/failures.dart';
import 'package:task_dashboard/core/errors/exception/exceptions.dart';
import 'package:task_dashboard/core/errors/failures/failure_handler.dart';
import 'package:task_dashboard/core/errors/exception/exception_handler.dart';
import 'package:task_dashboard/core/networking/api_client.dart';

abstract class BaseService {
  final ApiClient apiClient;
  BaseService(this.apiClient);

  /// Handles API calls that return BaseModel and converts exceptions to failures
  /// This method makes API calls and converts the response using the provided fromJson callback
  ///
  /// Set [isVoid] to true for operations that don't return data (like DELETE)
  ///
  /// Example:
  /// ```dart
  /// // For requests with data response
  /// final result = await handleBaseModelApiRequests<GetPostsModel>(
  ///   httpMethod: HttpMethods.get,
  ///   endPoint: '/posts',
  ///   fromJson: (json) => GetPostsModel.fromJson(json),
  /// );
  ///
  /// // For void requests (no data response)
  /// final result = await handleVoidApiRequests(
  ///   httpMethod: HttpMethods.delete,
  ///   endPoint: '/posts/1',
  /// );
  /// ```
  Future<Either<GFailure, T>> handleBaseModelApiRequests<T extends BaseModel>({
    required HttpMethods httpMethod,
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await apiClient.safeApiCall(
        httpMethod: httpMethod,
        endPoint: endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Parse response using the provided fromJson callback
      final T model = fromJson(response.data as Map<String, dynamic>);
      return Right(model);
    } on DioException catch (dioException) {
      // Use FailureHandler for DioException
      return Left(FailureHandler.handleDioFailure(dioException));
    } on GException catch (gException) {
      return Left(GExceptionHandler.exceptionToFailure(gException));
    } catch (e) {
      return Left(
        ParsingFailure(message: 'Failed to parse response: ${e.toString()}'),
      );
    }
  }

  /// Convenience method for void operations (DELETE, etc.)
  /// Returns Either<GFailure, void> for operations that don't return data
  Future<Either<GFailure, void>> handleVoidApiRequests({
    required HttpMethods httpMethod,
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      await apiClient.safeApiCall(
        httpMethod: httpMethod,
        endPoint: endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return const Right(null);
    } on DioException catch (dioException) {
      // Use FailureHandler for DioException
      return Left(FailureHandler.handleDioFailure(dioException));
    } on GException catch (gException) {
      return Left(GExceptionHandler.exceptionToFailure(gException));
    } catch (e) {
      return Left(
        ParsingFailure(message: 'Failed to parse response: ${e.toString()}'),
      );
    }
  }

  /// Handles generic API requests with custom logic
  Future<Either<GFailure, T>> handleGenericApiRequests<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return Right(result);
    } on DioException catch (dioException) {
      return Left(FailureHandler.handleDioFailure(dioException));
    } on GException catch (gException) {
      return Left(GExceptionHandler.exceptionToFailure(gException));
    } catch (e) {
      return Left(GUnknownFailure(message: e.toString()));
    }
  }

  /// Handles API requests for repository services
  /// Returns the model directly without Either wrapper
  /// Throws exceptions that can be caught by the repository layer
  Future<T> handleDirectApiRequest<T>({
    required HttpMethods httpMethod,
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await apiClient.safeApiCall(
        httpMethod: httpMethod,
        endPoint: endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // Handle null response
      if (response.data == null) {
        log('handleDirectApiRequest - response.data is null');
        throw UnknownException(message: 'Received null response from server');
      }

      // Handle case where response.data might not be a Map
      if (response.data is! Map<String, dynamic>) {
        log(
          'handleDirectApiRequest - response.data is not a Map: ${response.data.runtimeType}',
        );
        // If it's a string or other type, try to wrap it
        if (response.data is String && (response.data as String).isEmpty) {
          throw UnknownException(
            message: 'Received empty response from server',
          );
        }
        // Try to convert to Map if possible
        final dataMap = response.data is Map
            ? Map<String, dynamic>.from(response.data as Map)
            : {'data': response.data};
        return fromJson(dataMap);
      }

      // Handle empty Map response (common for PUT requests that return 200 with {})
      final responseMap = response.data as Map<String, dynamic>;
      if (responseMap.isEmpty) {
        log(
          'handleDirectApiRequest - response.data is empty Map, treating as success',
        );
        // For empty responses, return a minimal success response
        // This is common for PUT/DELETE operations that return 200 with {}
        // We'll create a minimal response that indicates success
        return fromJson({'success': true});
      }

      // Parse and return the model using the provided callback
      return fromJson(responseMap);
    } on DioException catch (dioException) {
      log('handleDirectApiRequest - caught DioException');
      log(
        'handleDirectApiRequest - dioException.response?.data: ${dioException.response?.data}',
      );
      // Re-throw as GException for repository to handle
      final gException = _convertDioExceptionToGException(dioException);
      log('handleDirectApiRequest - gException.message: ${gException.message}');
      throw gException;
    } on GException {
      // Re-throw GException as is
      rethrow;
    } catch (e) {
      // Re-throw as GException
      log('handleDirectApiRequest - caught exception: $e');
      throw UnknownException(
        message: 'Failed to parse response: ${e.toString()}',
      );
    }
  }

  /// Handles void API requests for repository services
  /// Returns void on success, throws exception on failure
  Future<void> handleDirectVoidRequest({
    required HttpMethods httpMethod,
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await apiClient.safeApiCall(
        httpMethod: httpMethod,
        endPoint: endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      // For void requests, we don't need to parse the response
      // Just check if the status code indicates success (2xx)
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        // Success - return void
        return;
      }
      // If status code is not in 2xx range, treat as error
      throw UnknownException(
        message: 'Request failed with status code: ${response.statusCode}',
      );
    } on DioException catch (dioException) {
      // Re-throw as GException for repository to handle
      throw _convertDioExceptionToGException(dioException);
    } on GException {
      // Re-throw GException as is
      rethrow;
    } catch (e) {
      // Re-throw as GException
      if (e is GException) {
        rethrow;
      }
      throw UnknownException(message: 'Request failed: ${e.toString()}');
    }
  }

  /// Converts DioException to GException for repository layer
  GException _convertDioExceptionToGException(DioException dioException) {
    log('_convertDioExceptionToGException - called');
    // Extract error message from response body, not from exception.message
    // Get response body data - this is the JSON response body
    final responseData = dioException.response?.data;
    log('_convertDioExceptionToGException - responseData: $responseData');
    log(
      '_convertDioExceptionToGException - responseData type: ${responseData.runtimeType}',
    );

    // Extract error message from response body (responseData['message'])
    final errorMessage = _extractErrorMessageFromResponse(responseData);
    log(
      '_convertDioExceptionToGException - extracted errorMessage: $errorMessage',
    );

    switch (dioException.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return GNetworkException(message: errorMessage);

      case DioExceptionType.badResponse:
        return GServerException(
          statusCode: dioException.response?.statusCode ?? 500,
          message: errorMessage,
        );

      case DioExceptionType.cancel:
        return GNetworkException(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return GServerException(
          statusCode: dioException.response?.statusCode ?? 500,
          message: errorMessage,
        );
    }
  }

  /// Extract error message from response body
  /// Priority: errors['otp'][0] -> errors[field][0] -> message -> error -> generic
  String _extractErrorMessageFromResponse(dynamic responseData) {
    if (responseData == null) {
      return 'Network error occurred';
    }

    // Handle Map response (JSON object) - this is response.body
    if (responseData is Map) {
      // FIRST PRIORITY: Get from errors['otp'][0] if exists
      final errors = responseData['errors'];
      if (errors != null && errors is Map && errors.isNotEmpty) {
        // Check for 'otp' key first
        final otpError = errors['otp'];
        if (otpError != null) {
          if (otpError is List && otpError.isNotEmpty) {
            final errorMsg = otpError[0]?.toString().trim() ?? '';
            if (errorMsg.isNotEmpty) {
              return errorMsg;
            }
          } else if (otpError is String && otpError.trim().isNotEmpty) {
            return otpError.trim();
          }
        }

        // If no 'otp' key, get first error from first field
        final firstErrorKey = errors.keys.first;
        final firstErrorValue = errors[firstErrorKey];

        if (firstErrorValue != null) {
          if (firstErrorValue is List && firstErrorValue.isNotEmpty) {
            final errorMsg = firstErrorValue[0]?.toString().trim() ?? '';
            if (errorMsg.isNotEmpty) {
              return errorMsg;
            }
          } else if (firstErrorValue is String &&
              firstErrorValue.trim().isNotEmpty) {
            return firstErrorValue.trim();
          }
        }
      }

      // Second priority: Get message from response.body['message']
      final message = responseData['message'];
      if (message != null && message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      // Third priority: Get from error field
      final error = responseData['error'];
      if (error != null && error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    // Handle String response
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData.trim();
    }

    // Fallback: generic error
    return 'Network error occurred';
  }
}
