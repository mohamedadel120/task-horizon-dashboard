import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/constants/assets/app_icons.dart';

class SuccessPopupIcon extends StatelessWidget {
  const SuccessPopupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82.w,
      height: 82.w,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Center(
        child: Image.asset(
          AppIcons.IN_PROGRESS,
          width: 80.w,
          height: 80.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class PendingPopupIcon extends StatelessWidget {
  const PendingPopupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      height: 82.w,
      child: Image.asset(
        AppIcons.WAITING,
        width: 82.w,
        height: 82.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class ErrorPopupIcon extends StatelessWidget {
  const ErrorPopupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      height: 82.w,
      child: Image.asset(
        AppIcons.REMOVE,
        width: 82.w,
        height: 82.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class ConfirmPopupIcon extends StatelessWidget {
  const ConfirmPopupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      height: 82.w,
      child: Image.asset(
        AppIcons.TRASH,
        width: 82.w,
        height: 82.w,
        fit: BoxFit.contain,
      ),
    );
  }
}

class OfflinePopupIcon extends StatelessWidget {
  const OfflinePopupIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.w,
      height: 82.w,
      child: Image.asset(
        AppIcons.NO_WIFI,
        width: 82.w,
        height: 82.w,
        fit: BoxFit.contain,
      ),
    );
  }
}
