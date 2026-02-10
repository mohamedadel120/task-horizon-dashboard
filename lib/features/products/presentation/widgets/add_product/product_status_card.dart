import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';

class ProductStatusCard extends StatelessWidget {
  const ProductStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) =>
          previous.apiStates !=
          current
              .apiStates, // Rebuild when status changes (triggered by setStatus)
      builder: (context, state) {
        final cubit = context.read<ProductsCubit>();
        final currentStatus = cubit.selectedStatus;

        return SectionCard(
          title: 'Product Status',
          child: Column(
            children: [
              _buildRadioOption(
                title: 'Active',
                value: ProductStatus.active,
                groupValue: currentStatus,
                onChanged: (value) => cubit.setStatus(value!),
                activeColor: ColorManager.mainColor,
              ),
              SizedBox(height: 12.h),
              _buildRadioOption(
                title: 'Draft',
                value: ProductStatus.draft,
                groupValue: currentStatus,
                onChanged: (value) => cubit.setStatus(value!),
                activeColor: ColorManager.textSecondary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioOption({
    required String title,
    required ProductStatus value,
    required ProductStatus groupValue,
    required ValueChanged<ProductStatus?> onChanged,
    required Color activeColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: value == groupValue ? activeColor : ColorManager.grey300,
        ),
        borderRadius: BorderRadius.circular(8.r),
        color: value == groupValue ? activeColor.withValues(alpha: 0.05) : null,
      ),
      child: RadioListTile<ProductStatus>(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: value == groupValue ? FontWeight.w600 : FontWeight.w400,
            color: ColorManager.black,
          ),
        ),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
