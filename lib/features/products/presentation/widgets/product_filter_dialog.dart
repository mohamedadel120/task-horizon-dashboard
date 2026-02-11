import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';

class ProductFilterDialog extends StatefulWidget {
  const ProductFilterDialog({super.key});

  @override
  State<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends State<ProductFilterDialog> {
  String? _categoryId;
  ProductStatus? _status;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProductsCubit>().state;
    _categoryId = state.filterCategoryId;
    _status = state.filterStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) {
        final categories = categoriesState.categories;
        return AlertDialog(
          title: const Text('Filter products'),
          content: SizedBox(
            width: 320.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String?>(
                  value: _categoryId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorManager.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: ColorManager.grey300),
                    ),
                  ),
                  hint: const Text('All categories'),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All categories'),
                    ),
                    ...categories.map((c) => DropdownMenuItem<String?>(
                          value: c.id,
                          child: Text(c.name),
                        )),
                  ],
                  onChanged: (value) => setState(() => _categoryId = value),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<ProductStatus?>(
                  value: _status,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorManager.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: ColorManager.grey300),
                    ),
                  ),
                  hint: const Text('All statuses'),
                  items: [
                    const DropdownMenuItem<ProductStatus?>(
                      value: null,
                      child: Text('All statuses'),
                    ),
                    ...ProductStatus.values.map((s) => DropdownMenuItem<ProductStatus?>(
                          value: s,
                          child: Text(s.displayName),
                        )),
                  ],
                  onChanged: (value) => setState(() => _status = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<ProductsCubit>().clearFilters();
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                context.read<ProductsCubit>().setFilters(
                      categoryId: _categoryId,
                      status: _status,
                    );
                if (context.mounted) Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: ColorManager.mainColor,
              ),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
