import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';

class SidebarMenuItem extends StatelessWidget {
  final String? iconPath;
  final IconData? materialIcon;
  final String label;
  final String route;
  final bool isSelected;
  final int? badgeCount;
  final bool comingSoon;

  const SidebarMenuItem({
    super.key,
    this.iconPath,
    this.materialIcon,
    required this.label,
    required this.route,
    this.isSelected = false,
    this.badgeCount,
    this.comingSoon = false,
  }) : assert(
         iconPath != null || materialIcon != null,
         'Either iconPath or materialIcon must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (comingSoon) {
          AppSnackBar.showComingSoon(context);
        } else {
          context.go(route);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.mainColor.withValues(alpha: 0.1)
              : ColorManager.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            // Icon - SVG or Material
            if (iconPath != null)
              SvgPicture.asset(
                iconPath!,
                width: 20.w,
                height: 20.h,
                colorFilter: ColorFilter.mode(
                  isSelected
                      ? ColorManager.mainColor
                      : ColorManager.textSecondary,
                  BlendMode.srcIn,
                ),
              )
            else if (materialIcon != null)
              Icon(
                materialIcon,
                size: 20.sp,
                color: isSelected
                    ? ColorManager.mainColor
                    : ColorManager.textSecondary,
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? ColorManager.mainColor
                      : ColorManager.textPrimary,
                ),
              ),
            ),
            if (badgeCount != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: ColorManager.mainColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorManager.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
