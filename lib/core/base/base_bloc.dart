import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_cubit.dart';

// Base Event
abstract class BaseEvent {}

class LoadEvent extends BaseEvent {}

// Reuse BaseState, LoadingState, SuccessState, ErrorState, InitialState from base_cubit.dart

class BaseBloc<T> extends Bloc<BaseEvent, BaseState> {
  BaseBloc() : super(InitialState()) {
    on<LoadEvent>(_onLoadEvent);
  }
  void _onLoadEvent(LoadEvent event, Emitter<BaseState> emit) {
    emit(LoadingState());
  }
}

