import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_filter_dialog.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_mobile_card.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';

class ProductsMobileView extends StatelessWidget {
  const ProductsMobileView({
    super.key,
    required this.searchController,
    required this.state,
  });

  final TextEditingController searchController;
  final ProductsState state;

  @override
  Widget build(BuildContext context) {
    final padding = context.pagePadding;
    final products = state.products;
    final totalProducts = products.length;
    final outOfStock = products.where((p) => p.stock <= 0).length;
    final totalValue = products.fold<double>(
      0,
      (sum, product) => sum + (product.price * product.stock),
    );
    final categoryCount = products.map((p) => p.categoryId).toSet().length;
    final filtered = state.filteredProducts;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 20.h),
          _buildStatsGrid(
            totalProducts,
            outOfStock,
            totalValue,
            categoryCount,
          ),
          SizedBox(height: 20.h),
          _buildFiltersColumn(context),
          SizedBox(height: 20.h),
          _buildProductList(filtered),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Manage your product catalog, inventory, and pricing.',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/products/add'),
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.mainColor,
              foregroundColor: ColorManager.white,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(
    int totalProducts,
    int outOfStock,
    double totalValue,
    int categoryCount,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Products',
                value: '$totalProducts',
                iconPath: 'assets/icons/product_icon.svg',
                iconColor: ColorManager.mainColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: 'Out of Stock',
                value: '$outOfStock',
                icon: Icons.warning_amber_outlined,
                iconColor: ColorManager.warning,
                valueColor: outOfStock > 0 ? ColorManager.error : ColorManager.black,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Value',
                value: NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '\$',
                  decimalDigits: 0,
                ).format(totalValue),
                icon: Icons.attach_money,
                iconColor: ColorManager.success,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: StatCard(
                title: 'Categories',
                value: '$categoryCount',
                iconPath: 'assets/icons/categories_icon.svg',
                iconColor: ColorManager.mainColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFiltersColumn(BuildContext context) {
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
                icon: const Icon(Icons.filter_list, size: 20),
                label: Text(
                  state.hasActiveFilters ? 'Filter (on)' : 'Filter',
                  style: TextStyle(fontSize: 13.sp),
                ),
                style: OutlinedButton.styleFrom(
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
                icon: const Icon(Icons.file_download_outlined, size: 20),
                label: Text('Export', style: TextStyle(fontSize: 13.sp)),
                style: OutlinedButton.styleFrom(
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

  Widget _buildProductList(List<Product> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.h),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 48.sp,
                color: ColorManager.textTertiary,
              ),
              SizedBox(height: 16.h),
              Text(
                'No products match your filters',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: ColorManager.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return ProductMobileCard(product: product);
      },
    );
  }
}
