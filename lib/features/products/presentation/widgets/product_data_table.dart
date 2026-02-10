import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/confirm_dialog.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';

class ProductDataTable extends StatelessWidget {
  const ProductDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final products = state.products;
        final status = state.getStatus('fetch_products');

        // Loading state
        if (status == BaseStatus.loading && products.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
            ),
            padding: EdgeInsets.all(48.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Error state
        if (status == BaseStatus.error && products.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
            ),
            padding: EdgeInsets.all(48.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48.sp,
                    color: ColorManager.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.getError('fetch_products') ??
                        'Failed to load products',
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

        // Empty state
        if (products.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
            ),
            padding: EdgeInsets.all(48.w),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 48.sp,
                    color: ColorManager.textTertiary,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No products found',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add your first product to get started',
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

        // Success state with data
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorManager.grey300),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: ColorManager.grey300),
                  ),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell('Product', flex: 3),
                    _buildHeaderCell('Category', flex: 2),
                    _buildHeaderCell('Price', flex: 1),
                    _buildHeaderCell('Stock', flex: 1),
                    _buildHeaderCell('Status', flex: 1),
                    _buildHeaderCell('Actions', flex: 1),
                  ],
                ),
              ),
              // Table Rows
              ...products.map(
                (product) =>
                    _buildProductRow(context: context, product: product),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: ColorManager.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProductRow({
    required BuildContext context,
    required Product product,
  }) {
    final isOutOfStock = product.stock <= 0;
    final isActive = product.status == ProductStatus.active;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManager.grey200)),
      ),
      child: Row(
        children: [
          // Product
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: ColorManager.bgLight,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child:
                        product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_outlined,
                                size: 24.sp,
                                color: ColorManager.textTertiary,
                              );
                            },
                          )
                        : Icon(
                            Icons.inventory_2_outlined,
                            size: 24.sp,
                            color: ColorManager.textTertiary,
                          ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        product.sku,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorManager.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Category
          Expanded(
            flex: 2,
            child: Text(
              product.categoryName ?? product.categoryId,
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.textSecondary,
              ),
            ),
          ),
          // Price
          Expanded(
            flex: 1,
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.black,
              ),
            ),
          ),
          // Stock
          Expanded(
            flex: 1,
            child: Text(
              isOutOfStock ? '-' : '${product.stock}',
              style: TextStyle(
                fontSize: 14.sp,
                color: isOutOfStock
                    ? ColorManager.error
                    : ColorManager.textSecondary,
              ),
            ),
          ),
          // Status
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isActive && !isOutOfStock
                    ? ColorManager.greenLight
                    : ColorManager.redLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                isOutOfStock ? 'Out of Stock' : product.status.displayName,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive && !isOutOfStock
                      ? ColorManager.greenDark
                      : ColorManager.redDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Actions
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined, size: 18.sp),
                  color: ColorManager.textSecondary,
                  onPressed: () {
                    context.go('/products/edit/${product.id}', extra: product);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 12.w),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18.sp),
                  color: ColorManager.error,
                  onPressed: () async {
                    final confirmed = await ConfirmDialog.showDelete(
                      context,
                      itemName: product.name,
                    );
                    if (confirmed && context.mounted) {
                      context.read<ProductsCubit>().deleteProduct(product.id);
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
