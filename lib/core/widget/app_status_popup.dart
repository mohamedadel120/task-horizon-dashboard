import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/helpers/spacing.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/theming/styles.dart';
import 'package:task_dashboard/core/widget/popups/popup_actions.dart';
import 'package:task_dashboard/core/widget/popups/popup_icons.dart';

enum AppStatusPopupType { success, pending, error, confirm, offline, custom }

class AppStatusPopup extends StatelessWidget {
  const AppStatusPopup({
    super.key,
    required this.title,
    required this.type,
    this.subtitle,
    this.actions = const [],
    this.customIcon,
    this.backgroundColor,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final AppStatusPopupType type;
  final List<AppStatusPopupAction> actions;
  final Widget? customIcon;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required AppStatusPopupType type,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
    Widget? customIcon,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: actions.isEmpty,
      builder: (_) => AppStatusPopup(
        title: title,
        subtitle: subtitle,
        type: type,
        actions: actions,
        customIcon: customIcon,
        backgroundColor: backgroundColor,
        padding: padding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 420.w),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(28.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: customIcon ?? _buildDefaultIcon(),
            ),
            verticalSpace(24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueSemiBold,
            ),
            if (subtitle != null) ...[
              verticalSpace(12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyles.font14GrayRegular,
              ),
            ],
            if (actions.isNotEmpty) ...[
              verticalSpace(24),
              PopupActionsSection(
                actions: actions,
                accentColor: _getAccentColor(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    switch (type) {
      case AppStatusPopupType.success:
        return const SuccessPopupIcon();
      case AppStatusPopupType.pending:
        return const PendingPopupIcon();
      case AppStatusPopupType.error:
        return const ErrorPopupIcon();
      case AppStatusPopupType.confirm:
        return const ConfirmPopupIcon();
      case AppStatusPopupType.offline:
        return const OfflinePopupIcon();
      case AppStatusPopupType.custom:
        return Container(
          width: 82.w,
          height: 82.w,
          decoration: BoxDecoration(
            color: ColorManager.mainColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.info_outline_rounded,
            color: ColorManager.mainColor,
            size: 38.w,
          ),
        );
    }
  }

  Color _getAccentColor() {
    switch (type) {
      case AppStatusPopupType.success:
      case AppStatusPopupType.pending:
      case AppStatusPopupType.offline:
        return ColorManager.mainColor;
      case AppStatusPopupType.error:
        return ColorManager.error;
      case AppStatusPopupType.confirm:
        return ColorManager.error;
      case AppStatusPopupType.custom:
        return ColorManager.mainColor;
    }
  }
}

class AppStatusPopups {
  const AppStatusPopups._();

  static Future<T?> success<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
  }) {
    return AppStatusPopup.show<T>(
      context,
      title: title,
      subtitle: subtitle,
      type: AppStatusPopupType.success,
      actions: actions,
    );
  }

  static Future<T?> pending<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
  }) {
    return AppStatusPopup.show<T>(
      context,
      title: title,
      subtitle: subtitle,
      type: AppStatusPopupType.pending,
      actions: actions,
    );
  }

  static Future<T?> error<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
  }) {
    return AppStatusPopup.show<T>(
      context,
      title: title,
      subtitle: subtitle,
      type: AppStatusPopupType.error,
      actions: actions,
    );
  }

  static Future<T?> confirm<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
  }) {
    return AppStatusPopup.show<T>(
      context,
      title: title,
      subtitle: subtitle,
      type: AppStatusPopupType.confirm,
      actions: actions,
    );
  }

  static Future<T?> offline<T>(
    BuildContext context, {
    required String title,
    String? subtitle,
    List<AppStatusPopupAction> actions = const [],
  }) {
    return AppStatusPopup.show<T>(
      context,
      title: title,
      subtitle: subtitle,
      type: AppStatusPopupType.offline,
      actions: actions,
    );
  }
}
