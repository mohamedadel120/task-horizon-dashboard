import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

/// Top bar search field (desktop only). Used by [AppTopBar].
class AppTopBarSearch extends StatelessWidget {
  const AppTopBarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 200) return const SizedBox.shrink();
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
    );
  }
}
