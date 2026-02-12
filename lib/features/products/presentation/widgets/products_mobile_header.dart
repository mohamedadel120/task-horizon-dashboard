import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';

/// Products screen header for mobile (title, subtitle, Add Product button).
class ProductsMobileHeader extends StatelessWidget {
  const ProductsMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
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
              minimumSize: const Size(double.infinity, 48),
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
}
