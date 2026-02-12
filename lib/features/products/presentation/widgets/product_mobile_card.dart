import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/confirm_dialog.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';

class ProductMobileCard extends StatelessWidget {
  const ProductMobileCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = product.stock <= 0;
    final quantityColor = isOutOfStock
        ? ColorManager.error
        : product.stock <= 5
            ? ColorManager.warning
            : ColorManager.success;

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            width: 64.w,
                            height: 64.w,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product.categoryName ?? product.categoryId,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: ColorManager.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.mainColor,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: quantityColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${product.stock} in stock',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: ColorManager.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: ColorManager.textSecondary),
                    onSelected: (value) async {
                      if (value == 'edit') {
                        context.go('/products/edit/${product.id}', extra: product);
                      } else if (value == 'delete') {
                        final confirmed = await ConfirmDialog.showDelete(
                          context,
                          itemName: product.name,
                        );
                        if (confirmed && context.mounted) {
                          context.read<ProductsCubit>().deleteProduct(product.id);
                        }
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 20.sp),
                            SizedBox(width: 12.w),
                            Text('Edit', style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, size: 20.sp, color: ColorManager.error),
                            SizedBox(width: 12.w),
                            Text('Delete', style: TextStyle(fontSize: 14.sp, color: ColorManager.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: ColorManager.grey100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Icon(
        Icons.inventory_2_outlined,
        size: 28.sp,
        color: ColorManager.textTertiary,
      ),
    );
  }
}
