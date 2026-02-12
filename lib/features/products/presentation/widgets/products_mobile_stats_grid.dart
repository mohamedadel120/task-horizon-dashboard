import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';

/// Four stat cards in 2x2 grid for products mobile view.
class ProductsMobileStatsGrid extends StatelessWidget {
  const ProductsMobileStatsGrid({
    super.key,
    required this.totalProducts,
    required this.outOfStock,
    required this.totalValue,
    required this.categoryCount,
  });

  final int totalProducts;
  final int outOfStock;
  final double totalValue;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    final gap = context.isMobile ? 10.0 : 12.0;
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
            SizedBox(width: gap.w),
            Expanded(
              child: StatCard(
                title: 'Out of Stock',
                value: '$outOfStock',
                icon: Icons.warning_amber_outlined,
                iconColor: ColorManager.warning,
                valueColor:
                    outOfStock > 0 ? ColorManager.error : ColorManager.black,
              ),
            ),
          ],
        ),
        SizedBox(height: gap.h),
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
            SizedBox(width: gap.w),
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
}
