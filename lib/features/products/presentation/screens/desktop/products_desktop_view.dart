import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_data_table.dart';
import 'package:task_dashboard/features/products/presentation/widgets/products_desktop_stats_row.dart';
import 'package:task_dashboard/features/products/presentation/widgets/products_filters_row.dart';

class ProductsDesktopView extends StatelessWidget {
  const ProductsDesktopView({
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

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          ProductsDesktopStatsRow(
            totalProducts: totalProducts,
            outOfStock: outOfStock,
            totalValue: totalValue,
            categoryCount: categoryCount,
          ),
          SizedBox(height: 24.h),
          ProductsFiltersRow(
            searchController: searchController,
            hasActiveFilters: state.hasActiveFilters,
          ),
          SizedBox(height: 24.h),
          const ProductDataTable(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Products',
                style: TextStyle(
                  fontSize: 28.sp,
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
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => context.go('/products/add'),
          icon: const Icon(Icons.add),
          label: const Text('Add Product'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.mainColor,
            foregroundColor: ColorManager.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }
}
