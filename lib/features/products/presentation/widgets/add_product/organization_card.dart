import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/category_dropdown.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return SectionCard(
      title: 'Organization',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CategoryDropdown(),
          SizedBox(height: 20.h),
          DashboardTextField(
            label: 'Product Type',
            hint: 'e.g. Headphones',
            controller: cubit.productTypeController,
          ),
          SizedBox(height: 20.h),
          DashboardTextField(
            label: 'Tags',
            hint: 'Enter tags...',
            controller: cubit.tagsController,
            helperText: 'Separate tags with commas',
          ),
        ],
      ),
    );
  }
}
