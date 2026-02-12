import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';

class ProductsDesktopStatsRow extends StatelessWidget {
  const ProductsDesktopStatsRow({
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
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total Products',
            value: '$totalProducts',
            iconPath: 'assets/icons/product_icon.svg',
            iconColor: ColorManager.mainColor,
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: StatCard(
            title: 'Out of Stock',
            value: '$outOfStock',
            icon: Icons.warning_amber_outlined,
            iconColor: ColorManager.warning,
            valueColor: outOfStock > 0 ? ColorManager.error : ColorManager.black,
          ),
        ),
        SizedBox(width: 20.w),
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
        SizedBox(width: 20.w),
        Expanded(
          child: StatCard(
            title: 'Categories',
            value: '$categoryCount',
            iconPath: 'assets/icons/categories_icon.svg',
            iconColor: ColorManager.mainColor,
          ),
        ),
      ],
    );
  }
}
