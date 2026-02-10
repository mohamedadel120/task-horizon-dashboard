class ApiStatusCode {
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int UNAUTHORIZED = 401;
  static const int FORBIDDEN = 403;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;
  static const int API_LOGIC_ERROR = 422;

  // Local status codes
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECEIVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEFAULT = -7;
  static const int PARSING_ERROR = -8;
  static const int SERIALIZATION_ERROR = -9;
  static const int STORAGE_ERROR = -10;
  static const int PERMISSION_ERROR = -11;
  static const int NETWORK_SECURITY = -12;
  static const int RUNTIME_ERROR = -13;
  static const int PLATFORM_ERROR = -14;
  static const int UNKNOWN_ERROR = -15;
  static const int VALIDATION_ERROR = -16;
  static const int STATE_ERROR = -17;
}

