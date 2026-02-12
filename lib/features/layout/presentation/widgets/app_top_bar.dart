import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/app_top_bar_search.dart';

class AppTopBar extends StatelessWidget {
  final List<String> breadcrumbs;
  final bool showMenuButton;
  final VoidCallback? onMenuTap;

  const AppTopBar({
    super.key,
    this.breadcrumbs = const [],
    this.showMenuButton = false,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.pagePadding;
    final isMobile = context.isMobile;
    return Container(
      height: 56.h.clamp(48, 64),
      padding: EdgeInsets.symmetric(horizontal: padding),
      decoration: BoxDecoration(
        color: ColorManager.white,
        border: const Border(
          bottom: BorderSide(color: ColorManager.grey300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenuButton && onMenuTap != null)
            IconButton(
              icon: Icon(Icons.menu, size: 24.sp),
              onPressed: onMenuTap,
              padding: EdgeInsets.all(12.w),
              style: IconButton.styleFrom(
                minimumSize: const Size(ResponsiveContext.minTouchTarget, ResponsiveContext.minTouchTarget),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          if (showMenuButton && onMenuTap != null) SizedBox(width: 4.w),
          // Breadcrumbs – truncate on mobile
          if (breadcrumbs.isNotEmpty)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < breadcrumbs.length; i++) ...[
                      if (i > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          if (!isMobile) SizedBox(width: 12.w),
          if (!isMobile)
            Expanded(
              child: Center(child: const AppTopBarSearch()),
            ),
          const Spacer(),
          // Action Buttons – ensure 48px touch targets
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: 24.sp,
              color: ColorManager.textSecondary,
            ),
            onPressed: () => AppSnackBar.showComingSoon(context),
            style: IconButton.styleFrom(
              minimumSize: const Size(ResponsiveContext.minTouchTarget, ResponsiveContext.minTouchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 24.sp,
              color: ColorManager.textSecondary,
            ),
            onPressed: () => AppSnackBar.showComingSoon(context),
            style: IconButton.styleFrom(
              minimumSize: const Size(ResponsiveContext.minTouchTarget, ResponsiveContext.minTouchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
