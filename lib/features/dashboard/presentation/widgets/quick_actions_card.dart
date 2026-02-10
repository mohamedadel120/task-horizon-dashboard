import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class QuickActionsCard extends StatelessWidget {
  const QuickActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.grey300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick actions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: QuickActionTile(
                  iconPath: 'assets/icons/product_icon.svg',
                  label: 'Products',
                  onTap: () => context.go('/products'),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: QuickActionTile(
                  iconPath: 'assets/icons/categories_icon.svg',
                  label: 'Categories',
                  onTap: () => context.go('/categories'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickActionTile extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String label;
  final VoidCallback onTap;

  const QuickActionTile({
    super.key,
    this.icon,
    this.iconPath,
    required this.label,
    required this.onTap,
  }) : assert(icon != null || iconPath != null,
            'Either icon or iconPath must be provided');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.w, horizontal: 16.w),
          decoration: BoxDecoration(
            color: ColorManager.bgLight,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorManager.grey300),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorManager.mainColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath!,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: ColorFilter.mode(
                          ColorManager.mainColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(icon!, size: 24.sp, color: ColorManager.mainColor),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14.sp,
                color: ColorManager.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
