import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Add Product',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Add a new product to your inventory catalog.',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorManager.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          // Form
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - Basic Info
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildSection(
                      title: 'Basic Information',
                      child: Column(
                        children: [
                          DashboardTextField(
                            label: 'Product Name',
                            hint: 'e.g. Wireless Headphones Pro',
                            controller: _nameController,
                            required: true,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: DashboardTextField(
                                  label: 'SKU',
                                  hint: 'e.g. SKU-001',
                                  controller: _skuController,
                                  required: true,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Category',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                          vertical: 12.h,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          borderSide: const BorderSide(
                                            color: ColorManager.grey300,
                                          ),
                                        ),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value: 'electronics',
                                          child: Text('Electronics'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'furniture',
                                          child: Text('Furniture'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'apparel',
                                          child: Text('Apparel'),
                                        ),
                                      ],
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          DashboardTextField(
                            label: 'Description',
                            hint: 'Describe the product features...',
                            controller: _descriptionController,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildSection(
                      title: 'Pricing & Stock',
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DashboardTextField(
                                  label: 'Price',
                                  hint: '0.00',
                                  controller: _priceController,
                                  required: true,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: DashboardTextField(
                                  label: 'Stock Quantity',
                                  hint: '0',
                                  controller: _stockController,
                                  required: true,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24.w),
              // Right Column - Images
              Expanded(
                flex: 1,
                child: _buildSection(
                  title: 'Product Image',
                  child: Column(
                    children: [
                      DashboardTextField(
                        label: 'Image URL',
                        hint: 'https://example.com/image.jpg',
                        controller: _imageUrlController,
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                          color: ColorManager.bgLight,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: ColorManager.grey300,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 48.sp,
                              color: ColorManager.textTertiary,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Upload image or enter URL above',
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
              ),
            ],
          ),
          SizedBox(height: 32.h),
          // Actions
          Row(
            children: [
              OutlinedButton(
                onPressed: () => context.go('/products'),
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
                child: const Text('Cancel'),
              ),
              SizedBox(width: 12.w),
              ElevatedButton(
                onPressed: () {
                  context.go('/products');
                },
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
                child: const Text('Create Product'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          child,
        ],
      ),
    );
  }
}
