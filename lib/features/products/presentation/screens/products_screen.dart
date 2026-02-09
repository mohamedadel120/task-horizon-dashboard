import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_data_table.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        color: ColorManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Manage your product inventory and pricing.',
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
          // Stats Row
          Row(
            children: [
              const Expanded(
                child: StatCard(
                  title: 'Total Products',
                  value: '347',
                  icon: Icons.inventory_2_outlined,
                  iconColor: ColorManager.mainColor,
                  trend: '12%',
                  trendUp: true,
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: StatCard(
                  title: 'Active Products',
                  value: '332',
                  icon: Icons.check_circle_outline,
                  iconColor: ColorManager.success,
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: StatCard(
                  title: 'Out of Stock',
                  value: '15',
                  icon: Icons.warning_amber_outlined,
                  iconColor: ColorManager.warning,
                  subtitle: 'Need restocking',
                ),
              ),
              SizedBox(width: 20.w),
              const Expanded(
                child: StatCard(
                  title: 'Total Value',
                  value: '\$89.4K',
                  icon: Icons.attach_money,
                  iconColor: ColorManager.success,
                  trend: '8%',
                  trendUp: true,
                ),
              ),
            ],
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
  }
}
