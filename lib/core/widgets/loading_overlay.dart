import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorManager.mainColor,
                ),
              ),
              if (message != null) ...[
                SizedBox(height: 16.h),
                Text(
                  message!,
                  style: TextStyle(fontSize: 14.sp, color: ColorManager.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Show loading overlay
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingOverlay(message: message),
    );
  }

  /// Hide loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}
