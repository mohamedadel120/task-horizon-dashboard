enum BaseStatus { initial, loading, success, error }

class BaseApiState {
  final BaseStatus status;
  final String? error;
  final dynamic responseModel;
  BaseApiState({
    required this.status,
    required this.error,
    required this.responseModel,
  });
  BaseApiState copyWith({
    BaseStatus? status,
    String? error,
    dynamic responseData,
  }) {
    return BaseApiState(
      status: status ?? this.status,
      error: error ?? this.error,
      responseModel: responseData ?? responseModel,
    );
  }
  BaseApiState.initial() : this(status: BaseStatus.initial, error: null, responseModel: null);
}

abstract class BaseState {
  final Map<String, BaseApiState> apiStates;

  const BaseState({this.apiStates = const {}});

  BaseState copyWith({Map<String, BaseApiState>? apiStates});

  BaseStatus getStatus(String operation) =>
      apiStates[operation]?.status ?? BaseStatus.initial;

  String? getError(String operation) => apiStates[operation]?.error;

  dynamic getData(String operation) => apiStates[operation]?.responseModel;

  BaseApiState getApiState(String operation) =>
      apiStates[operation] ??
      BaseApiState(
        status: BaseStatus.initial,
        error: null,
        responseModel: null,
      );
}

