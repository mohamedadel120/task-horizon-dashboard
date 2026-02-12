import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';

/// Edit/delete and last-updated row for [CategoryCard].
class CategoryCardActions extends StatelessWidget {
  const CategoryCardActions({
    super.key,
    required this.lastUpdated,
    this.onEdit,
    this.onDelete,
  });

  final String lastUpdated;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14.sp,
          color: ColorManager.textTertiary,
        ),
        SizedBox(width: 4.w),
        Text(
          'Updated $lastUpdated',
          style: TextStyle(
            fontSize: 12.sp,
            color: ColorManager.textTertiary,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.edit_outlined, size: 20.sp),
          color: ColorManager.textSecondary,
          onPressed: onEdit,
          style: IconButton.styleFrom(
            minimumSize: const Size(
              ResponsiveContext.minTouchTarget,
              ResponsiveContext.minTouchTarget,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: 8.w),
        InkWell(
          onTap: onDelete,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: SvgPicture.asset(
              'assets/icons/delete_icon.svg',
              width: 30.w,
              height: 30.h,
              colorFilter: ColorFilter.mode(
                ColorManager.error,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
