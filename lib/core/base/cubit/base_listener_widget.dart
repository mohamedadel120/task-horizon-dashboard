import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';

class BaseBlocListener<B extends BlocBase<S>, S extends BaseState>
    extends StatelessWidget {
  final String endPoint;
  final Widget child;

  // ListenWhen condition - only listen when this returns true
  final bool Function(S previous, S current)? listenWhen;

  // Listener callbacks
  final void Function(BuildContext context, S state)? onLoading;
  final void Function(BuildContext context, S state)? onSuccess;
  final void Function(BuildContext context, S state, String error)? onError;
  final void Function(BuildContext context, S state)? onInitial;

  const BaseBlocListener({
    super.key,
    required this.endPoint,
    required this.child,
    this.listenWhen,
    this.onLoading,
    this.onSuccess,
    this.onError,
    this.onInitial,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
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
            onSuccess?.call(context, state);
            break;
          case BaseStatus.error:
            final error = apiState.error ?? 'Something went wrong';
            onError?.call(context, state, error);
            break;
        }
      },
      child: child,
    );
  }

  // Default listenWhen: only listen when the specific endpoint status changes
  bool _defaultListenWhen(S previous, S current) {
    final previousApiState = previous.getApiState(endPoint);
    final currentApiState = current.getApiState(endPoint);

    return previousApiState.status != currentApiState.status;
  }
}
