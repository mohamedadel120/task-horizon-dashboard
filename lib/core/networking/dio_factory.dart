import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';
import 'package:task_dashboard/core/helpers/constance.dart';
import 'package:task_dashboard/core/helpers/shared_pref.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders();
      addDioInterceptor();

      return dio!;
    } else {
      return dio!;
    }
  }

  static void addDioHeaders() async {
    dio?.options.headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken)}',
    };
  }

  static void setTokenIntoHeaderAfterLogin(String token) {
    dio?.options.headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    };
  }

  static void clearToken() {
    dio?.options.headers = {"Accept": "application/json"};
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printRequestData: true,
          printResponseData: true,

          printResponseMessage: true,
        ),
      ),
      // PrettyDioLogger(
      //   requestBody: true,
      //   requestHeader: true,
      //   responseHeader: true,
      // ),
    );
  }
}
