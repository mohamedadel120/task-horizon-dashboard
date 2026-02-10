import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class AppTopBar extends StatelessWidget {
  final List<String> breadcrumbs;

  const AppTopBar({super.key, this.breadcrumbs = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: const Border(
          bottom: BorderSide(color: ColorManager.grey300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Breadcrumbs
          if (breadcrumbs.isNotEmpty)
            Row(
              children: [
                for (int i = 0; i < breadcrumbs.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Icon(
                        Icons.chevron_right,
                        size: 16.sp,
                        color: ColorManager.textTertiary,
                      ),
                    ),
                  Text(
                    breadcrumbs[i],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: i == breadcrumbs.length - 1
                          ? ColorManager.textPrimary
                          : ColorManager.textSecondary,
                      fontWeight: i == breadcrumbs.length - 1
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          SizedBox(width: 24.w),
          Expanded(
            child: Center(
              child: Container(
                height: 40.h,
                constraints: BoxConstraints(maxWidth: 320.w),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: ColorManager.textTertiary,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: ColorManager.textTertiary,
                    ),
                    filled: true,
                    fillColor: ColorManager.bgLight,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Action Buttons
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: 24.sp,
              color: ColorManager.textSecondary,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 24.sp,
              color: ColorManager.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
