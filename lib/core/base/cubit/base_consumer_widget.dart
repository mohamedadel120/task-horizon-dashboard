import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/base/base_model.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/widget/shimmer_skeleton.dart';

class BaseBlocConsumer<
  B extends BlocBase<S>,
  S extends BaseState,
  T extends BaseModel
>
    extends StatelessWidget {
  final String endPoint;
  final Widget Function(BuildContext, T) builder;
  final Widget? loading;
  final Widget Function(String error)? errorBuilder;
  final T fakeDataForShimmer;

  // BuildWhen condition - only rebuild when this returns true
  final bool Function(S previous, S current)? buildWhen;

  // ListenWhen condition - only listen when this returns true
  final bool Function(S previous, S current)? listenWhen;

  // Listener callbacks
  final void Function(BuildContext context, S state)? onLoading;
  final void Function(BuildContext context, S state, T data)? onSuccess;
  final void Function(BuildContext context, S state, String error)? onError;
  final void Function(BuildContext context, S state)? onInitial;

  const BaseBlocConsumer({
    super.key,
    required this.endPoint,
    required this.builder,
    this.loading,
    this.errorBuilder,
    required this.fakeDataForShimmer,
    this.buildWhen,
    this.listenWhen,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.onInitial,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<B, S>(
      buildWhen: buildWhen ?? _defaultBuildWhen,
      listenWhen: listenWhen ?? _defaultListenWhen,
      listener: (context, state) {
        final apiState = state.getApiState(endPoint);

        switch (apiState.status) {
          case BaseStatus.initial:
            onInitial?.call(context, state);
            break;
          case BaseStatus.loading:
            onLoading?.call(context, state);
            break;
          case BaseStatus.success:
            if (apiState.responseModel != null) {
              onSuccess?.call(context, state, apiState.responseModel! as T);
            }
            break;
          case BaseStatus.error:
            final error = apiState.error ?? 'Something went wrong';
            onError?.call(context, state, error);
            break;
        }
      },
      builder: (context, state) {
        final apiState = state.getApiState(endPoint);

        if (apiState.status == BaseStatus.loading) {
          return ShimmerSkeleton(
            isLoading: true,
            child: builder(context, fakeDataForShimmer),
          );
        }
        if (apiState.status == BaseStatus.error) {
          final error = apiState.error ?? 'Something went wrong';
          return errorBuilder?.call(error) ??
              Center(
                child: Text(error, style: const TextStyle(color: Colors.red)),
              );
        }
        if (apiState.status == BaseStatus.success) {
          if (apiState.responseModel == null) {
            return builder(context, null as T);
          }
          return builder(context, apiState.responseModel! as T);
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Default buildWhen: rebuild when the specific endpoint status changes
  bool _defaultBuildWhen(S previous, S current) {
    final previousApiState = previous.getApiState(endPoint);
    final currentApiState = current.getApiState(endPoint);

    return previousApiState.status != currentApiState.status;
  }

  // Default listenWhen: listen when the specific endpoint status changes
  bool _defaultListenWhen(S previous, S current) {
    final previousApiState = previous.getApiState(endPoint);
    final currentApiState = current.getApiState(endPoint);

    return previousApiState.status != currentApiState.status;
  }
}
