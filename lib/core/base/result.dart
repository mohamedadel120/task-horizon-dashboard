/// Result wrapper for operations that can fail
/// Provides type-safe error handling
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result._({this.data, this.error, required this.isSuccess});

  /// Create a successful result
  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  /// Create a failed result
  factory Result.failure(String error) {
    return Result._(error: error, isSuccess: false);
  }

  /// Check if result is a failure
  bool get isFailure => !isSuccess;

  /// Execute callback with data if successful
  void when({
    required Function(T data) success,
    required Function(String error) failure,
  }) {
    if (isSuccess && data != null) {
      success(data as T);
    } else if (error != null) {
      failure(error!);
    }
  }
}
