import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseState {
  const BaseState();
}

class LoadingState extends BaseState {}

class SuccessState<T> extends BaseState {
  final T data;
  const SuccessState(this.data);
}

class SuccessWithoutData extends BaseState {
  SuccessWithoutData();
}

class ErrorState extends BaseState {
  final String message;
  const ErrorState(this.message);
}

class InitialState extends BaseState {}

class BaseCubit<T> extends Cubit<BaseState> {
  BaseCubit() : super(InitialState());

  void emitLoading() => emit(LoadingState());
  void emitSuccess(T data) => emit(SuccessState<T>(data));
  void emitError(String message) => emit(ErrorState(message));
  void emitSuccessVoid() => emit(SuccessWithoutData());
}

