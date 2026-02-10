import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:task_dashboard/core/helpers/api_constants.dart';
import 'package:task_dashboard/core/helpers/constance.dart';
import 'package:task_dashboard/core/helpers/language_helper.dart';
import 'package:task_dashboard/core/helpers/shared_pref.dart';
import 'package:task_dashboard/core/routing/app_router.dart';
import 'package:task_dashboard/core/routing/routes.dart';
import 'package:task_dashboard/core/networking/dio_factory.dart';
import 'package:task_dashboard/core/cache/cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// final talkerDioLoggerSettings = TalkerDioLoggerSettings(
//       enabled: true,

//     );
// final talkerDioLogger = TalkerDioLogger(
//   talker: talker,
//   settings: TalkerDioLoggerSettings(
//     printRequestData: true,
//     printResponseData: true,
//     printResponseMessage: true,
//     printRequestHeaders: true,
//     printResponseHeaders: false,
//   ),
// );

/// Authentication interceptor for automatic token handling
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Accept-Language header is already added by LanguageInterceptor
    // No need to add it here again

    // Skip adding token for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get token from secure storage
    final token = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle user blocked (403 Forbidden with user_blocked message)
    if (err.response?.statusCode == 403) {
      final responseData = err.response?.data;
      final message = _extractMessage(responseData);

      // Check if error message indicates user is blocked
      if (message != null &&
          (message.contains('user_blocked') ||
              message.contains('errors.auth.user_blocked'))) {
        log('ðŸš« User is blocked - clearing data and redirecting to login');
        await _handleUserBlocked();
        return super.onError(err, handler);
      }
    }

    // Handle token expiration (401 Unauthorized)
    if (err.response?.statusCode == 401) {
      // Skip clearing tokens for auth endpoints (login, register, verify-otp)
      // These endpoints may return 401 during normal flow
      if (_isAuthEndpoint(err.requestOptions.path)) {
        return super.onError(err, handler);
      }

      // Try to refresh token
      final refreshSuccess = await _refreshToken(err.requestOptions);

      if (refreshSuccess) {
        // Retry the original request with new token
        try {
          final clonedRequest = await _retryRequest(err.requestOptions);
          return handler.resolve(clonedRequest);
        } catch (e) {
          // If retry fails, proceed with original error
        }
      } else {
        // Refresh failed, clear tokens and redirect to login
        // But only if this is not an auth endpoint AND user is not in verify process
        // Check if user has cached token (in verify process)
        final cachedToken = await SharedPrefHelper.getSecuredString(
          SharedPrefKeys.cachedRegisterToken,
        );

        // Only clear tokens if user is not in verify process
        if (cachedToken.isEmpty) {
          await _clearTokens();
          // You might want to emit a logout event here
        } else {
          log(
            'âš ï¸ Skipping token clear on 401 - user is in verify OTP process',
          );
        }
      }
    }

    super.onError(err, handler);
  }

  /// Extract error message from response data
  String? _extractMessage(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String?;
    }

    if (responseData is String) {
      return responseData;
    }

    return null;
  }

  /// Handle user blocked - clear all data and redirect to login
  Future<void> _handleUserBlocked() async {
    try {
      // Clear all cached data
      await CacheManager.clearAllCache();

      // Clear tokens from secure storage
      const flutterSecureStorage = FlutterSecureStorage();
      await flutterSecureStorage.delete(key: SharedPrefKeys.userToken);
      await flutterSecureStorage.delete(
        key: SharedPrefKeys.cachedRegisterToken,
      );

      // Clear user data from SharedPreferences
      await SharedPrefHelper.removeData(SharedPrefKeys.userId);
      await SharedPrefHelper.removeData(SharedPrefKeys.cachedRegisterUserData);

      // Clear token from Dio
      DioFactory.clearToken();

      // Mark user as logged out
      isLoggedInUser = false;

      log('âœ… All user data cleared due to account being blocked');

      // Navigate to login screen
      // Use Future.microtask to ensure navigation happens after current frame
      Future.microtask(() {
        try {
          AppRouter.router.go(Routes.loginScreen);
          log('âœ… Redirected to login screen');
        } catch (e) {
          log('âŒ Error redirecting to login: $e');
        }
      });
    } catch (e) {
      log('âŒ Error handling user blocked: $e');
    }
  }

  /// Check if the endpoint is an authentication endpoint
  bool _isAuthEndpoint(String path) {
    const authEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/verify-otp', // Add verify-otp to auth endpoints
    ];
    return authEndpoints.any((endpoint) => path.contains(endpoint));
  }

  /// Get auth token from secure storage
  Future<String?> _getToken() async {
    try {
      final token = await SharedPrefHelper.getSecuredString(
        SharedPrefKeys.userToken,
      );
      return token.isEmpty ? null : token;
    } catch (e) {
      log('Error reading token: $e');
      return null;
    }
  }

  /// Get refresh token from secure storage
  Future<String?> _getRefreshToken() async {
    return null;
  }

  /// Store auth token in secure storage
  Future<void> storeToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
  }

  /// Store refresh token in secure storage
  Future<void> storeRefreshToken(String refreshToken) async {
    // Implement when refresh tokens are used
  }

  /// Store both tokens
  Future<void> storeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      storeToken(accessToken),
      storeRefreshToken(refreshToken),
    ]);
  }

  /// Clear all tokens
  /// IMPORTANT: Only clear if user is actually logged out
  /// Do NOT clear during verify OTP process
  Future<void> _clearTokens() async {
    // Check if user has a valid token before clearing
    // If token exists, don't clear it (user might be in verify process)
    final existingToken = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    // Only clear if token is already empty or user is explicitly logged out
    // This prevents clearing token during verify OTP process
    if (existingToken.isEmpty) {
      return; // Already empty, nothing to clear
    }

    // Check if there's a cached register token (user is in verify process)
    final cachedToken = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.cachedRegisterToken,
    );

    // If there's a cached token, user is in verify process - DON'T clear
    if (cachedToken.isNotEmpty) {
      log('âš ï¸ Skipping token clear - user is in verify OTP process');
      return;
    }

    // Only clear if user is actually logged out
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, '');
    log('Token cleared from AuthInterceptor');
  }

  /// Refresh the access token using refresh token
  Future<bool> _refreshToken(RequestOptions originalRequest) async {
    try {
      final refreshToken = await _getRefreshToken();
      if (refreshToken == null) return false;

      // Create a new Dio instance to avoid interceptor loops
      final dio = Dio();
      dio.options.baseUrl = originalRequest.baseUrl;

      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newAccessToken = data['access_token'] as String?;
        final newRefreshToken = data['refresh_token'] as String?;

        if (newAccessToken != null) {
          await storeToken(newAccessToken);
          if (newRefreshToken != null) {
            await storeRefreshToken(newRefreshToken);
          }
          return true;
        }
      }
    } catch (e) {
      log('Error refreshing token: $e');
    }
    return false;
  }

  /// Retry the original request with new token
  Future<Response> _retryRequest(RequestOptions requestOptions) async {
    final token = await _getToken();
    if (token != null) {
      requestOptions.headers['Authorization'] = 'Bearer $token';
    }

    final dio = Dio();
    dio.options = BaseOptions(
      baseUrl: requestOptions.baseUrl,
      connectTimeout: requestOptions.connectTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );

    return await dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
        validateStatus: requestOptions.validateStatus,
        receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
        followRedirects: requestOptions.followRedirects,
        maxRedirects: requestOptions.maxRedirects,
        requestEncoder: requestOptions.requestEncoder,
        responseDecoder: requestOptions.responseDecoder,
        listFormat: requestOptions.listFormat,
      ),
    );
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user by clearing all tokens
  Future<void> logout() async {
    await _clearTokens();
  }
}

/// Language interceptor for automatic Accept-Language header
class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get current language using LanguageHelper (consistent with other services)
    final language = await LanguageHelper.getLanguage();

    // Add Accept-Language header to all requests
    options.headers[ApiConstants.acceptLanguage] = language;

    super.onRequest(options, handler);
  }
}
