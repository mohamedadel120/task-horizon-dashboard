import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/confirm_dialog.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';

const int _kPageSize = 5;

class ProductDataTable extends StatefulWidget {
  const ProductDataTable({super.key});

  @override
  State<ProductDataTable> createState() => _ProductDataTableState();
}

class _ProductDataTableState extends State<ProductDataTable> {
  int _currentPage = 0;

  int _clampedPage(int totalCount) {
    final maxPage = totalCount <= 0 ? 0 : ((totalCount - 1) / _kPageSize).floor();
    return _currentPage.clamp(0, maxPage);
  }

  List<Product> _paginatedProducts(List<Product> products) {
    final page = _clampedPage(products.length);
    final start = page * _kPageSize;
    if (start >= products.length) return [];
    return products.skip(start).take(_kPageSize).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        final products = state.filteredProducts;
        final status = state.getStatus('fetch_products');

        // Reset to a valid page when filtered list shrinks
        final safePage = _clampedPage(products.length);
        if (safePage != _currentPage) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentPage = safePage);
          });
        }

        // Loading state
        if (status == BaseStatus.loading && products.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(48.w),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // Error state
        if (status == BaseStatus.error && products.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
              color: ColorManager.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: ColorManager.grey300),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
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
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ColorManager.grey300),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Table Header (Figma: Product Name, Category, Price, Quantity, Description, Actions)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorManager.grey100,
                  border: Border(
                    bottom: BorderSide(color: ColorManager.grey300),
                  ),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell('Product Name', flex: 3),
                    _buildHeaderCell('Category', flex: 1),
                    _buildHeaderCell('Price', flex: 1),
                    _buildHeaderCell('Quantity', flex: 1),
                    _buildHeaderCell('Description', flex: 2),
                    _buildHeaderCell('Actions', flex: 1),
                  ],
                ),
              ),
              // Table Rows (paginated)
              ..._paginatedProducts(products).map(
                (product) =>
                    _buildProductRow(context: context, product: product),
              ),
              _buildPaginationFooter(products.length),
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
          fontWeight: FontWeight.w600,
          color: ColorManager.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPaginationFooter(int totalCount) {
    final page = _clampedPage(totalCount);
    final start = totalCount == 0 ? 0 : (page * _kPageSize) + 1;
    final end = (page * _kPageSize + _kPageSize).clamp(0, totalCount);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ColorManager.grey300)),
      ),
      child: Row(
        children: [
          Text(
            'Showing $start-${end == 0 ? 0 : end} of $totalCount products',
            style: TextStyle(
              fontSize: 13.sp,
              color: ColorManager.textSecondary,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorManager.grey300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: const Text('Previous'),
          ),
          SizedBox(width: 12.w),
          OutlinedButton(
            onPressed: (page + 1) * _kPageSize < totalCount
                ? () => setState(() => _currentPage++)
                : null,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: ColorManager.grey300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductRow({
    required BuildContext context,
    required Product product,
  }) {
    final isOutOfStock = product.stock <= 0;
    final isLowStock = product.stock > 0 && product.stock <= 5;
    // Figma: green = in stock, orange = low, red = out
    final quantityColor = isOutOfStock
        ? ColorManager.error
        : isLowStock
            ? ColorManager.warning
            : ColorManager.success;
    final subtitle = product.productType ?? product.sku;
    final desc = product.description ?? '—';
    final descriptionSnippet =
        desc.length > 35 ? '${desc.substring(0, 35)}...' : desc;

    return Container(
      key: ValueKey(product.id),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: ColorManager.grey200)),
      ),
      child: Row(
        children: [
          // Product Name (image + name + variant/subtitle)
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorManager.textTertiary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Category (pill)
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorManager.grey100,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorManager.grey300),
              ),
              child: Text(
                product.categoryName ?? product.categoryId,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorManager.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
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
                fontWeight: FontWeight.w500,
                color: ColorManager.textPrimary,
              ),
            ),
          ),
          // Quantity (colored dot + number)
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: quantityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  isOutOfStock ? '0' : '${product.stock}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorManager.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Description (truncated)
          Expanded(
            flex: 2,
            child: Text(
              descriptionSnippet,
              style: TextStyle(
                fontSize: 13.sp,
                color: ColorManager.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Actions (edit pencil, delete red trash)
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
                SizedBox(width: 8.w),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/delete_icon.svg',
                    width: 33.w,
                    height: 33.h,
                    colorFilter: ColorFilter.mode(
                      ColorManager.error,
                      BlendMode.srcIn,
                    ),
                  ),
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
