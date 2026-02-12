import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_filter_dialog.dart';

class ProductsFiltersRow extends StatelessWidget {
  const ProductsFiltersRow({
    super.key,
    required this.searchController,
    required this.hasActiveFilters,
  });

  final TextEditingController searchController;
  final bool hasActiveFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
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
        ),
        SizedBox(width: 12.w),
        OutlinedButton.icon(
          onPressed: () => _openFilterDialog(context),
          icon: const Icon(Icons.filter_list),
          label: Text(hasActiveFilters ? 'Filter (on)' : 'Filter'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            side: const BorderSide(color: ColorManager.grey300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        OutlinedButton.icon(
          onPressed: () => AppSnackBar.showComingSoon(context),
          icon: const Icon(Icons.file_download_outlined),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            side: const BorderSide(color: ColorManager.grey300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  void _openFilterDialog(BuildContext context) {
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
  }
}
