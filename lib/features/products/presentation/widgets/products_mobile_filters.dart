import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_filter_dialog.dart';

/// Search field and Filter/Export buttons for products mobile view.
class ProductsMobileFilters extends StatelessWidget {
  const ProductsMobileFilters({
    super.key,
    required this.searchController,
    required this.hasActiveFilters,
  });

  final TextEditingController searchController;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: searchController,
          onChanged: (value) =>
              context.read<ProductsCubit>().setSearchQuery(value),
          decoration: InputDecoration(
            hintText: 'Search products...',
            prefixIcon: const Icon(Icons.search),
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorManager.grey300),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  final productsCubit = context.read<ProductsCubit>();
                  final categoriesCubit = context.read<CategoriesCubit>();
                  showDialog(
                    context: context,
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: productsCubit),
                        BlocProvider.value(value: categoriesCubit),
                      ],
                      child: const ProductFilterDialog(),
                    ),
                  );
                },
                icon: Icon(Icons.filter_list, size: 20.sp),
                label: Text(
                  hasActiveFilters ? 'Filter (on)' : 'Filter',
                  style: TextStyle(fontSize: 13.sp),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: const BorderSide(color: ColorManager.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => AppSnackBar.showComingSoon(context),
                icon: Icon(Icons.file_download_outlined, size: 20.sp),
                label: Text('Export', style: TextStyle(fontSize: 13.sp)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  side: const BorderSide(color: ColorManager.grey300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
