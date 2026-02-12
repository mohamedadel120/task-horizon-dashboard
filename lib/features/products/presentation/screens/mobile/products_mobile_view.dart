import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_mobile_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/products_mobile_filters.dart';
import 'package:task_dashboard/features/products/presentation/widgets/products_mobile_header.dart';
import 'package:task_dashboard/features/products/presentation/widgets/products_mobile_stats_grid.dart';

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
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductsMobileHeader(),
          SizedBox(height: 18.h),
          ProductsMobileStatsGrid(
            totalProducts: totalProducts,
            outOfStock: outOfStock,
            totalValue: totalValue,
            categoryCount: categoryCount,
          ),
          SizedBox(height: 18.h),
          ProductsMobileFilters(
            searchController: searchController,
            hasActiveFilters: state.hasActiveFilters,
          ),
          SizedBox(height: 18.h),
          _buildProductList(filtered),
        ],
      ),
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
        return ProductMobileCard(
          key: ValueKey(product.id),
          product: product,
        );
      },
    );
  }
}
