import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/category_dropdown.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        final addStatus = state.getStatus('add_product');

        if (addStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Product created successfully!');
          cubit.clearForm();
          context.go('/products');
        } else if (addStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('add_product') ?? 'Failed to create product',
          );
        }
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        buildWhen: (previous, current) =>
            previous.getStatus('add_product') !=
            current.getStatus('add_product'),
        builder: (context, state) {
          final isLoading =
              state.getStatus('add_product') == BaseStatus.loading;

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
                    color: ColorManager.black,
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
                // Form in single container
                Container(
                  constraints: BoxConstraints(maxWidth: 800.w),
                  padding: EdgeInsets.all(32.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorManager.grey300),
                  ),
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DashboardTextField(
                          label: 'Product Name',
                          hint: 'e.g. Wireless Headphones Pro',
                          controller: cubit.nameController,
                          required: true,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Product name is required';
                            }
                            if (value.trim().length < 2) {
                              return 'Product name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: DashboardTextField(
                                label: 'SKU',
                                hint: 'e.g. PROD-001',
                                controller: cubit.skuController,
                                required: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'SKU is required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(child: const CategoryDropdown()),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        DashboardTextField(
                          label: 'Description',
                          hint: 'Describe the product features...',
                          controller: cubit.descriptionController,
                          maxLines: 4,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: DashboardTextField(
                                label: 'Price',
                                hint: '0.00',
                                controller: cubit.priceController,
                                required: true,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Price is required';
                                  }
                                  final price = double.tryParse(value);
                                  if (price == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (price <= 0) {
                                    return 'Price must be greater than 0';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: DashboardTextField(
                                label: 'Stock Quantity',
                                hint: '0',
                                controller: cubit.stockController,
                                required: true,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Stock quantity is required';
                                  }
                                  final stock = int.tryParse(value);
                                  if (stock == null) {
                                    return 'Enter a valid number';
                                  }
                                  if (stock < 0) {
                                    return 'Stock cannot be negative';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        DashboardTextField(
                          label: 'Product Image URL',
                          hint: 'https://example.com/image.jpg',
                          helperText:
                              'Paste a direct link to an image (JPG, PNG, WebP).',
                          controller: cubit.imageUrlController,
                        ),
                        SizedBox(height: 32.h),
                        // Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => context.go('/products'),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 14.h,
                                ),
                                side: const BorderSide(
                                  color: ColorManager.grey300,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: const Text('Cancel'),
                            ),
                            SizedBox(width: 12.w),
                            ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final error = await cubit.submitProduct();
                                      if (error != null && context.mounted) {
                                        AppSnackBar.showError(context, error);
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.mainColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 14.h,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : const Text('Create Product'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
