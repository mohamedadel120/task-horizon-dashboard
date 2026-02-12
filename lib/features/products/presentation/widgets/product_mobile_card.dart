import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/products/presentation/widgets/product_mobile_card_content.dart';

class ProductMobileCard extends StatelessWidget {
  const ProductMobileCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(product.id),
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: ColorManager.grey200),
      ),
      child: InkWell(
        onTap: () => context.go('/products/edit/${product.id}', extra: product),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ProductMobileCardContent(product: product),
        ),
      ),
    );
  }
}
