import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/errors/failures/failures.dart';

abstract class BaseCubit<S extends BaseState> extends Cubit<S> {
  BaseCubit(super.initialState);

  void handleApiCall<T>({
    required String endPoint,
    required Future<Either<GFailure, T>> Function() apiCall,
  }) async {
    log('endPoint: $endPoint');
    startOperation(endPoint);
    final result = await apiCall();
    result.fold(
      (failure) => failOperation(endPoint, failure.message),
      (data) => successOperation(endPoint, data: data),
    );
  }

  void startOperation(String operation) {
    emit(
      state.copyWith(
            apiStates: {
              ...state.apiStates,
              operation: BaseApiState(
                status: BaseStatus.loading,
                error: null,
                responseModel: null,
              ),
            },
          )
          as S,
    );
  }

  void successOperation(String operation, {dynamic data}) {
    log('successOperation: $operation');
    log('data: $data');
    emit(
      state.copyWith(
            apiStates: {
              ...state.apiStates,
              operation: BaseApiState(
                status: BaseStatus.success,
                error: null,
                responseModel: data,
              ),
            },
          )
          as S,
    );
  }

  void failOperation(String operation, String error) {
    log('failOperation: $operation');
    log('error: $error');
    emit(
      state.copyWith(
            apiStates: {
              ...state.apiStates,
              operation: BaseApiState(
                status: BaseStatus.error,
                error: error,
                responseModel: null,
              ),
            },
          )
          as S,
    );
  }
}
