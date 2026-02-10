import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/helpers/spacing.dart';
import 'package:task_dashboard/core/routing/app_router.dart';
import 'package:task_dashboard/core/routing/routes.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widget/app_button.dart';
import 'package:task_dashboard/core/widget/auth_guard/cubit/auth_guard_cubit.dart';

enum PopupActionType { browseWithoutLogin, goToLogin, custom }

class AppStatusPopupAction {
  const AppStatusPopupAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.backgroundColor,
    this.textColor,
    this.actionType = PopupActionType.custom,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final Color? backgroundColor;
  final Color? textColor;
  final PopupActionType actionType;
}

class PopupActionsSection extends StatelessWidget {
  const PopupActionsSection({
    super.key,
    required this.actions,
    required this.accentColor,
  });

  final List<AppStatusPopupAction> actions;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          _buildButton(context, actions[i], accentColor),
          if (i != actions.length - 1) verticalSpace(12),
        ],
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    AppStatusPopupAction action,
    Color accentColor,
  ) {
    void handlePress() {
      print('Button pressed: ${action.label}');

      // Hide dialog in cubit if available
      try {
        final cubit = context.read<AuthGuardCubit>();
        cubit.hideDialog();
      } catch (_) {
        // Cubit might not be available, continue anyway
      }

      // Get router before closing dialog
      final router = AppRouter.router;

      // Close dialog immediately
      Navigator.of(context, rootNavigator: true).pop();

      // Execute action callback
      action.onPressed();

      // Use SchedulerBinding to ensure navigation happens after frame
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Use Future.microtask to ensure navigation happens after dialog is fully closed
        Future.microtask(() {
          // Handle navigation based on action type
          try {
            switch (action.actionType) {
              case PopupActionType.browseWithoutLogin:
                print('Navigating to bottomNavBar: ${Routes.bottomNavBar}');
                router.go(Routes.bottomNavBar);
                print('Navigation command executed');
                break;
              case PopupActionType.goToLogin:
                print('Navigating to loginScreen: ${Routes.loginScreen}');
                router.push(Routes.loginScreen);
                print('Navigation command executed');
                break;
              case PopupActionType.custom:
                // Custom action, navigation handled in onPressed
                break;
            }
          } catch (e) {
            print('Navigation error: $e');
          }
        });
      });
    }

    if (action.isPrimary) {
      return AppButton(
        text: action.label,
        onPressed: handlePress,
        backgroundColor: action.backgroundColor ?? ColorManager.mainColor,
        borderRadius: 24.r,
        height: 50.h,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: handlePress,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          side: BorderSide(color: Colors.grey.shade300, width: 1.w),
          backgroundColor: Colors.white,
        ),
        child: Text(
          action.label,
          style: TextStyle(
            color: action.textColor ?? ColorManager.textDark100,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
