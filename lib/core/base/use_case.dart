/// Base use case interface
/// All business logic operations should extend this
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}

/// Synchronous use case
abstract class SyncUseCase<Type, Params> {
  Type call(Params params);
}
