import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:task_dashboard/core/helpers/api_constants.dart';
import 'package:task_dashboard/core/errors/exception/exceptions.dart';
import 'package:task_dashboard/core/networking/interceptors.dart';
import 'package:task_dashboard/core/networking/network_info.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

/// Enum for HTTP methods supported by the API client
enum HttpMethods { get, post, put, patch, delete }

/// API Client using Dio for HTTP requests with error handling and network checks
class ApiClient {
  late final Dio _dio;
  final NetworkInfo _networkInfo;

  ApiClient({required NetworkInfo networkInfo, String? baseUrl})
    : _networkInfo = networkInfo {
    _dio = Dio();
    _initializeDio(baseUrl);
  }

  /// Initialize Dio with configurations and interceptors
  void _initializeDio(String? baseUrl) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl ?? ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    );

    // Add interceptors
    _dio.interceptors
      ..add(LanguageInterceptor())
      ..add(AuthInterceptor())
      ..add(
        TalkerDioLogger(
          settings: const TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: false,
            printRequestData: true,
            printResponseData: true,
            printResponseMessage: false,
          ),
        ),
      );
  }

  /// Safe API call with comprehensive error handling
  Future<Response> safeApiCall({
    required HttpMethods httpMethod,
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    await _checkConnectivity();

    try {
      log('httpMethod: $httpMethod');
      return await _executeApiCall(
        httpMethod: httpMethod,
        endPoint: endPoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (dioException) {
      throw _handleDioException(dioException);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  /// Handle Dio-specific exceptions and convert to GExceptions
  GException _handleDioException(DioException dioException) {
    // Extract error message from response body, not from exception.message
    final responseData = dioException.response?.data;
    final errorMessage = _extractErrorMessageFromResponse(responseData);

    switch (dioException.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return GNetworkException(
          message: errorMessage.isNotEmpty
              ? errorMessage
              : (dioException.message ?? 'Network connection failed'),
        );

      case DioExceptionType.badResponse:
        return GServerException(
          statusCode: dioException.response?.statusCode ?? 500,
          message: errorMessage.isNotEmpty
              ? errorMessage
              : (dioException.message ?? 'Server error occurred'),
        );

      case DioExceptionType.cancel:
        return GNetworkException(message: 'Request was cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return GServerException(
          statusCode: dioException.response?.statusCode ?? 500,
          message: errorMessage.isNotEmpty
              ? errorMessage
              : (dioException.message ?? 'An unexpected error occurred'),
        );
    }
  }

  /// Extract error message from response body
  /// Priority: errors['otp'][0] -> errors[field][0] -> message -> error -> generic
  String _extractErrorMessageFromResponse(dynamic responseData) {
    if (responseData == null) {
      return '';
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

    // Fallback: empty string (will use exception.message as fallback)
    return '';
  }

  // =========================== HTTP METHODS ===========================

  /// GET request with error handling
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return safeApiCall(
      httpMethod: HttpMethods.get,
      endPoint: path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST request with error handling
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return safeApiCall(
      httpMethod: HttpMethods.post,
      endPoint: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT request with error handling
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return safeApiCall(
      httpMethod: HttpMethods.put,
      endPoint: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH request with error handling
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    return safeApiCall(
      httpMethod: HttpMethods.patch,
      endPoint: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE request with error handling
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return safeApiCall(
      httpMethod: HttpMethods.delete,
      endPoint: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  // =========================== FILE OPERATIONS ===========================

  /// Download file with error handling
  Future<Response> download(
    String urlPath,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    await _checkConnectivity();

    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } on DioException catch (dioException) {
      throw _handleDioException(dioException);
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  /// Upload file with multipart and error handling
  Future<Response> uploadFile(
    String path,
    FormData formData, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
  }) async {
    return post(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  // =========================== UTILITY METHODS ===========================

  /// Update authentication token for requests
  void updateAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token from requests
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Get Dio instance for custom configurations if needed
  Dio get dio => _dio;

  // =========================== PRIVATE METHODS ===========================

  /// Check network connectivity before making requests
  Future<void> _checkConnectivity() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      throw GNetworkException(message: 'No internet connection available');
    }
  }

  /// Execute the actual API call based on HTTP method
  Future<Response> _executeApiCall({
    required HttpMethods httpMethod,
    required String endPoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    switch (httpMethod) {
      case HttpMethods.get:
        log('called the get method');
        final Response response = await _dio.get(
          endPoint,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        );
        log('response: ${response.data}');
        return response;

      case HttpMethods.post:
        return await _dio.post(
          endPoint,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );

      case HttpMethods.put:
        return await _dio.put(
          endPoint,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );

      case HttpMethods.patch:
        return await _dio.patch(
          endPoint,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        );

      case HttpMethods.delete:
        return await _dio.delete(
          endPoint,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        );
    }
  }
}
