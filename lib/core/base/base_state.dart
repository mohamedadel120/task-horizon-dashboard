/// Base state class for all feature states
/// Provides common state properties and methods
abstract class BaseState {
  final bool isLoading;
  final String? error;

  const BaseState({this.isLoading = false, this.error});

  bool get hasError => error != null;
  bool get isIdle => !isLoading && !hasError;
}
