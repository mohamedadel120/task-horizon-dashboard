import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class ProductDataTable extends StatelessWidget {
  const ProductDataTable({super.key});

  @override
  Widget build(BuildContext context) {
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
              border: Border(bottom: BorderSide(color: ColorManager.grey300)),
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
          _buildProductRow(
            name: 'Wireless Headphones Pro',
            image:
                'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
            sku: 'SKU-001',
            category: 'Electronics',
            price: '\$299.99',
            stock: 45,
            status: 'Active',
            statusActive: true,
          ),
          _buildProductRow(
            name: 'Ergonomic Office Chair',
            image: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
            sku: 'SKU-002',
            category: 'Furniture',
            price: '\$459.00',
            stock: 12,
            status: 'Active',
            statusActive: true,
          ),
          _buildProductRow(
            name: 'Minimalist Desk Lamp',
            image:
                'https://images.unsplash.com/photo-1507473885765-e6ed057f782c',
            sku: 'SKU-003',
            category: 'Electronics',
            price: '\$79.99',
            stock: 0,
            status: 'Out of Stock',
            statusActive: false,
          ),
          _buildProductRow(
            name: 'Premium Coffee Maker',
            image: 'https://images.unsplash.com/photo-1556911220-e15b29be8c8f',
            sku: 'SKU-004',
            category: 'Home & Kitchen',
            price: '\$189.50',
            stock: 28,
            status: 'Active',
            statusActive: true,
          ),
          _buildProductRow(
            name: 'Yoga Mat Premium',
            image: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b',
            sku: 'SKU-005',
            category: 'Sports & Outdoors',
            price: '\$49.99',
            stock: 67,
            status: 'Active',
            statusActive: true,
          ),
        ],
      ),
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
    required String name,
    required String image,
    required String sku,
    required String category,
    required String price,
    required int stock,
    required String status,
    required bool statusActive,
  }) {
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
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image_outlined,
                          size: 24.sp,
                          color: ColorManager.textTertiary,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
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
                        sku,
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
              category,
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
              price,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.textPrimary,
              ),
            ),
          ),
          // Stock
          Expanded(
            flex: 1,
            child: Text(
              stock == 0 ? '-' : '$stock',
              style: TextStyle(
                fontSize: 14.sp,
                color: stock == 0
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
                color: statusActive
                    ? ColorManager.greenLight
                    : ColorManager.redLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: statusActive
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
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 12.w),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18.sp),
                  color: ColorManager.error,
                  onPressed: () {},
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
