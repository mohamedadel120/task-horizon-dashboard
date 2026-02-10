import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, categoriesState) {
        final categories = categoriesState.categories;
        final isLoading =
            categoriesState.getStatus('fetch_categories') == BaseStatus.loading;

        return BlocBuilder<ProductsCubit, ProductsState>(
          buildWhen: (previous, current) =>
              previous.selectedCategoryId != current.selectedCategoryId,
          builder: (context, productsState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.black,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.error,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                DropdownButtonFormField<String>(
                  value: productsState.selectedCategoryId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: ColorManager.grey300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: ColorManager.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: ColorManager.mainColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(color: ColorManager.error),
                    ),
                  ),
                  hint: isLoading
                      ? const Text('Loading categories...')
                      : categories.isEmpty
                      ? const Text('No categories available')
                      : const Text('Select a category'),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: categories.isEmpty
                      ? null
                      : (value) {
                          context.read<ProductsCubit>().setCategory(value);
                        },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
