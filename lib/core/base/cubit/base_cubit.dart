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
    try {
      startOperation(endPoint);
      log('handleApiCall: calling apiCall for $endPoint');
      final result = await apiCall();
      log('handleApiCall: apiCall completed for $endPoint, folding result');
      result.fold(
        (failure) {
          log('handleApiCall: FAILURE for $endPoint: ${failure.message}');
          failOperation(endPoint, failure.message);
        },
        (data) {
          log('handleApiCall: SUCCESS for $endPoint, data: $data');
          successOperation(endPoint, data: data);
        },
      );
    } catch (e, stackTrace) {
      log('handleApiCall: EXCEPTION for $endPoint: $e');
      log('handleApiCall: STACK: $stackTrace');
      try {
        failOperation(endPoint, e.toString());
      } catch (_) {
        log('handleApiCall: Even failOperation threw!');
      }
    }
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

  /// Clears operation status so listeners don't re-trigger on success/error.
  /// Call this when handling success (e.g. before navigation) to avoid re-entry.
  void clearOperationStatuses(List<String> operations) {
    if (operations.isEmpty) return;
    final newApiStates = Map<String, BaseApiState>.from(state.apiStates);
    for (final op in operations) {
      newApiStates[op] = BaseApiState(
        status: BaseStatus.initial,
        error: null,
        responseModel: null,
      );
    }
    emit(state.copyWith(apiStates: newApiStates) as S);
  }
}
