import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_data_table.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        final deleteStatus = state.getStatus('delete_product');
        if (deleteStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Product deleted successfully');
        } else if (deleteStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('delete_product') ?? 'Failed to delete product',
          );
        }
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final products = state.products;

          // Calculate stats (order matches Figma: Total, Out of Stock, Total Value, Categories)
          final totalProducts = products.length;
          final outOfStock = products.where((p) => p.stock <= 0).length;
          final totalValue = products.fold<double>(
            0,
            (sum, product) => sum + (product.price * product.stock),
          );
          final categoryCount =
              products.map((p) => p.categoryId).toSet().length;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Stats Row (responsive)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 700;
                    final stats = [
                      StatCard(
                        title: 'Total Products',
                        value: '$totalProducts',
                        iconPath: 'assets/icons/product_icon.svg',
                        iconColor: ColorManager.mainColor,
                      ),
                      StatCard(
                        title: 'Out of Stock',
                        value: '$outOfStock',
                        icon: Icons.warning_amber_outlined,
                        iconColor: ColorManager.warning,
                        valueColor: outOfStock > 0
                            ? ColorManager.error
                            : ColorManager.black,
                      ),
                      StatCard(
                        title: 'Total Value',
                        value: NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0).format(totalValue),
                        icon: Icons.attach_money,
                        iconColor: ColorManager.success,
                      ),
                      StatCard(
                        title: 'Categories',
                        value: '$categoryCount',
                        iconPath: 'assets/icons/categories_icon.svg',
                        iconColor: ColorManager.mainColor,
                      ),
                    ];
                    if (isNarrow) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: stats[0]),
                              SizedBox(width: 12.w),
                              Expanded(child: stats[1]),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            children: [
                              Expanded(child: stats[2]),
                              SizedBox(width: 12.w),
                              Expanded(child: stats[3]),
                            ],
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(child: stats[0]),
                        SizedBox(width: 20.w),
                        Expanded(child: stats[1]),
                        SizedBox(width: 20.w),
                        Expanded(child: stats[2]),
                        SizedBox(width: 20.w),
                        Expanded(child: stats[3]),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24.h),
                // Filters and Search
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: ColorManager.grey300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: const BorderSide(
                              color: ColorManager.grey300,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list),
                      label: const Text('Filter'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        side: const BorderSide(color: ColorManager.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download_outlined),
                      label: const Text('Export'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        side: const BorderSide(color: ColorManager.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Table
                const ProductDataTable(),
              ],
            ),
          );
        },
      ),
    );
  }
}
