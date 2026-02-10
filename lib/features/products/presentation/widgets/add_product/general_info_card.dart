import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';

class GeneralInfoCard extends StatelessWidget {
  const GeneralInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return SectionCard(
      title: 'General Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardTextField(
            label: 'Product Name',
            hint: 'e.g. Wireless Noise-Cancelling Headphones',
            controller: cubit.nameController,
            required: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Product name is required';
              }
              if (value.trim().length < 2) {
                return 'Product name must be at least 2 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          DashboardTextField(
            label: 'Description',
            hint: 'Describe the product features, specs, and benefits...',
            controller: cubit.descriptionController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
