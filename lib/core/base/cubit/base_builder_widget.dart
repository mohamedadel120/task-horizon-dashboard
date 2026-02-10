import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/base/base_model.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/widget/shimmer_skeleton.dart';

class BaseBlocBuilder<
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

  const BaseBlocBuilder({
    super.key,
    required this.endPoint,
    required this.builder,
    this.loading,
    this.errorBuilder,
    required this.fakeDataForShimmer,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: buildWhen ?? _defaultBuildWhen,
      builder: (context, state) {
        final apiState = state.getApiState(endPoint);

        if (apiState.status == BaseStatus.loading) {
          if (loading != null) {
            return loading!;
          }
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
          final response = apiState.responseModel;
          if (response == null) {
            return const SizedBox.shrink();
          }
          return builder(context, response as T);
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
}
