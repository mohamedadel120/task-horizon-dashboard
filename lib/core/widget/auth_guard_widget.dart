import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/helpers/constance.dart';
import 'package:task_dashboard/core/widget/auth_guard/cubit/auth_guard_cubit.dart';
import 'package:task_dashboard/core/widget/auth_guard_helper.dart';

/// Widget that protects a route/screen by checking authentication
/// Shows dialog if user is not logged in
class AuthGuardWidget extends StatelessWidget {
  final Widget child;

  const AuthGuardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (isLoggedInUser) {
      return child;
    }

    return BlocProvider(
      create: (_) => AuthGuardCubit(),
      child: _AuthGuardContent(),
    );
  }
}

class _AuthGuardContent extends StatefulWidget {
  const _AuthGuardContent();

  @override
  State<_AuthGuardContent> createState() => _AuthGuardContentState();
}

class _AuthGuardContentState extends State<_AuthGuardContent> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_dialogShown) {
        _dialogShown = true;
        context.read<AuthGuardCubit>().showDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthGuardCubit, AuthGuardState>(
      listener: (context, state) {
        if (state.shouldShowDialog && !_dialogShown) {
          _dialogShown = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              AuthGuardHelper.showAuthDialog(context);
            }
          });
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}
