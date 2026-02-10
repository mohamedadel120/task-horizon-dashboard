import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class ConfirmDialog {
  /// Show confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDanger = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.black,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 14.sp, color: ColorManager.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                cancelText,
                style: TextStyle(color: ColorManager.black, fontSize: 14.sp),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDanger
                    ? ColorManager.error
                    : ColorManager.mainColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  /// Show delete confirmation
  static Future<bool> showDelete(
    BuildContext context, {
    required String itemName,
  }) {
    return show(
      context: context,
      title: 'Delete $itemName?',
      message:
          'This action cannot be undone. Are you sure you want to delete this $itemName?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      isDanger: true,
    );
  }
}
