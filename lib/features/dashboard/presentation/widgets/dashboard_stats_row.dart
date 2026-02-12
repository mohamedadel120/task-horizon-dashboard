import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/core/widgets/stat_card.dart';

const String _productIcon = 'assets/icons/product_icon.svg';
const String _categoriesIcon = 'assets/icons/categories_icon.svg';
const String _orderIcon = 'assets/icons/order_icon.svg';
const String _customerIcon = 'assets/icons/customer_icon.svg';

class DashboardStatsRow extends StatelessWidget {
  const DashboardStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final gap = isMobile ? 10.0 : 16.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700 || isMobile;
        if (isNarrow) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Products',
                      value: '—',
                      iconPath: _productIcon,
                      iconColor: ColorManager.mainColor,
                    ),
                  ),
                  SizedBox(width: gap.w),
                  Expanded(
                    child: StatCard(
                      title: 'Categories',
                      value: '—',
                      iconPath: _categoriesIcon,
                      iconColor: ColorManager.success,
                    ),
                  ),
                ],
              ),
              SizedBox(height: gap.h),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Orders',
                      value: '—',
                      iconPath: _orderIcon,
                      iconColor: ColorManager.accent100,
                    ),
                  ),
                  SizedBox(width: gap.w),
                  Expanded(
                    child: StatCard(
                      title: 'Customers',
                      value: '—',
                      iconPath: _customerIcon,
                      iconColor: ColorManager.statusInfo,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total Products',
                value: '—',
                iconPath: _productIcon,
                iconColor: ColorManager.mainColor,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: StatCard(
                title: 'Categories',
                value: '—',
                iconPath: _categoriesIcon,
                iconColor: ColorManager.success,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: StatCard(
                title: 'Orders',
                value: '—',
                iconPath: _orderIcon,
                iconColor: ColorManager.accent100,
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: StatCard(
                title: 'Customers',
                value: '—',
                iconPath: _customerIcon,
                iconColor: ColorManager.statusInfo,
              ),
            ),
          ],
        );
      },
    );
  }
}
