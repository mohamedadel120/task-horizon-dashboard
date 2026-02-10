import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return SectionCard(
      title: 'Preview',
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: cubit.imageUrlController,
        builder: (context, value, child) {
          final url = value.text.trim();
          if (url.isEmpty) {
            return _buildPlaceholder();
          }
          return Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              color: ColorManager.grey100,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: ColorManager.grey300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: ColorManager.grey100,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: ColorManager.grey300),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 64.sp,
              color: ColorManager.textTertiary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Upload an image to see a preview',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
          ),
        ),
      ],
    );
  }
}
