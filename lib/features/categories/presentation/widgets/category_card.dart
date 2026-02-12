import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';

class CategoryCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String description;
  final int itemCount;
  final String lastUpdated;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.itemCount,
    required this.lastUpdated,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorManager.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: ColorManager.bgLight,
                    child: Icon(
                      Icons.image_outlined,
                      size: 48.sp,
                      color: ColorManager.textTertiary,
                    ),
                  );
                },
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      itemCount == 1 ? '1 product' : '$itemCount products',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.mainColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorManager.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12.h),
                Row(
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
                        minimumSize: const Size(ResponsiveContext.minTouchTarget, ResponsiveContext.minTouchTarget),
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
                    // IconButton(
                    //   icon: Icon(Icons.delete, size: 18.sp),
                    //   color: ColorManager.error,
                    //   onPressed: onDelete,
                    //   padding: EdgeInsets.zero,
                    //   constraints: const BoxConstraints(),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
