import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_cubit.dart';
import 'package:task_dashboard/core/widget/shimmer_skeleton.dart';

class BaseStateWidget<T> extends StatelessWidget {
  final BlocBase<BaseState> cubit;
  final Widget Function(BuildContext, T) builder;
  final T fakeData;
  final Widget Function(String message)? errorBuilder;

  const BaseStateWidget({
    super.key,
    required this.cubit,
    required this.builder,
    required this.fakeData,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocBase<BaseState>, BaseState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is LoadingState) {
          // Use the shimmer skeleton with the fake data
          return ShimmerSkeleton(
            isLoading: true,
            child: builder(context, fakeData),
          );
        } else if (state is ErrorState) {
          if (errorBuilder != null) {
            return errorBuilder!(state.message);
          }
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is SuccessState<T>) {
          log('state.data: ${state.data}');
          return builder(context, state.data);
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
