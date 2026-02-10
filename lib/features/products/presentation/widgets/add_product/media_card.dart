import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return SectionCard(
      title: 'Product Media',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DashboardTextField(
                  label: 'Image URL',
                  hint: 'https://',
                  controller: cubit.imageUrlController,
                  helperText:
                      'Enter a direct link to an image (JPG, PNG, WebP).',
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                margin: EdgeInsets.only(top: 28.h), // Align with input field
                child: OutlinedButton(
                  onPressed: () {
                    // Trigger rebuild or validation if needed
                    // For now, the ValueListenableBuilder handles the preview
                    FocusScope.of(context).unfocus();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                    side: const BorderSide(color: ColorManager.grey300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: const Text('Fetch'),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.black,
            ),
          ),
          SizedBox(height: 8.h),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: cubit.imageUrlController,
            builder: (context, value, child) {
              final url = value.text.trim();
              if (url.isEmpty) {
                return _buildEmptyPreview();
              }
              return Container(
                width: double.infinity,
                height: 200.h,
                decoration: BoxDecoration(
                  color: ColorManager.bgLight,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: ColorManager.grey300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image_outlined,
                            size: 48.sp,
                            color: ColorManager.error,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Invalid Image URL',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: ColorManager.error,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        color: ColorManager.bgLight,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorManager.grey300,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48.sp,
            color: ColorManager.textTertiary,
          ),
          SizedBox(height: 8.h),
          Text(
            'Enter an image URL to see a preview',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorManager.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
