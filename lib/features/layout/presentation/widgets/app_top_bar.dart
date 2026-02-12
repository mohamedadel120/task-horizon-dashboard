import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';

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
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            ),
          if (showMenuButton && onMenuTap != null) SizedBox(width: 8.w),
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
          SizedBox(width: 12.w),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final showSearch = constraints.maxWidth > 200;
                  if (!showSearch) return const SizedBox.shrink();
                  return Container(
                    height: 40.h,
                    constraints: BoxConstraints(maxWidth: 320.w),
                    child: TextField(
                      onSubmitted: (value) {
                        final q = value.trim();
                        if (q.isEmpty) return;
                        context.go('/products?q=${Uri.encodeComponent(q)}');
                      },
                      decoration: InputDecoration(
                        hintText: 'Search products...',
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
                  );
                },
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
            onPressed: () => AppSnackBar.showComingSoon(context),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              Icons.help_outline,
              size: 24.sp,
              color: ColorManager.textSecondary,
            ),
            onPressed: () => AppSnackBar.showComingSoon(context),
          ),
        ],
      ),
    );
  }
}
