import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? iconPath;
  final Color iconColor;
  final Color? valueColor;
  final String? subtitle;
  final String? trend;
  final bool trendUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.iconPath,
    required this.iconColor,
    this.valueColor,
    this.subtitle,
    this.trend,
    this.trendUp = true,
  }) : assert(icon != null || iconPath != null,
            'Either icon or iconPath must be provided');

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = isMobile ? 14.w : 20.w;
    return Container(
      padding: EdgeInsets.all(padding),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: iconPath != null
                    ? SvgPicture.asset(
                        iconPath!,
                        width: 20.w,
                        height: 20.h,
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(icon!, size: 20.sp, color: iconColor),
              ),
              const Spacer(),
              if (trend != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: trendUp
                        ? ColorManager.greenLight
                        : ColorManager.redLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12.sp,
                        color: trendUp
                            ? ColorManager.greenDark
                            : ColorManager.redDark,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        trend!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: trendUp
                              ? ColorManager.greenDark
                              : ColorManager.redDark,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: isMobile ? 12.h : 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: (isMobile ? 22 : 28).sp,
              fontWeight: FontWeight.bold,
              color: valueColor ?? ColorManager.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: (isMobile ? 12 : 14).sp,
              color: ColorManager.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: ColorManager.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
