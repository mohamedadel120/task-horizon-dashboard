import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

/// Categories screen header for desktop (title, subtitle, Add Category button in a row).
class CategoriesDesktopHeader extends StatelessWidget {
  const CategoriesDesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Organize your products into catalog groups.',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorManager.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => context.go('/categories/add'),
          icon: const Icon(Icons.add),
          label: const Text('Add Category'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.mainColor,
            foregroundColor: ColorManager.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }
}
