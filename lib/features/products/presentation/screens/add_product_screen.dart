import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/general_info_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/media_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/organization_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/preview_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/pricing_inventory_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/product_status_card.dart';

class AddProductScreen extends StatefulWidget {
  final String? productId;
  final Product? product;

  const AddProductScreen({super.key, this.productId, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductsCubit>();
    if (widget.product != null) {
      cubit.initializeForm(widget.product);
    } else if (widget.productId != null) {
      // Fallback: Fetch product by ID (deep link or refresh)
      final product = cubit.getProductById(widget.productId!);
      if (product != null) {
        cubit.initializeForm(product);
      } else {
        cubit.fetchProductById(widget.productId!);
      }
    } else {
      cubit.initializeForm(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if screen is large enough for 2-column layout
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        final addStatus = state.getStatus('add_product');
        final updateStatus = state.getStatus('update_product');

        if (addStatus == BaseStatus.success ||
            updateStatus == BaseStatus.success) {
          final cubit = context.read<ProductsCubit>();
          cubit.clearOperationStatuses(['add_product', 'update_product']);
          final isEditing = widget.productId != null;
          AppSnackBar.showSuccess(
            context,
            isEditing
                ? 'Product updated successfully!'
                : 'Product created successfully!',
          );
          cubit.resetForm();
          if (context.mounted) context.go('/products');
        } else if (addStatus == BaseStatus.error ||
            updateStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('add_product') ??
                state.getError('update_product') ??
                (widget.productId != null
                    ? 'Failed to update product'
                    : 'Failed to create product'),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB), // Light grey background
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: context.read<ProductsCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 32.h),
                if (isDesktop) _buildDesktopLayout() else _buildMobileLayout(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) =>
          previous.getStatus('add_product') !=
              current.getStatus('add_product') ||
          previous.getStatus('update_product') !=
              current.getStatus('update_product'),
      builder: (context, state) {
        final isLoading =
            state.getStatus('add_product') == BaseStatus.loading ||
            state.getStatus('update_product') == BaseStatus.loading;

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productId != null
                        ? 'Edit Product'
                        : 'Add New Product',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.productId != null
                        ? 'Update the product details.'
                        : 'Add a new product to your inventory catalog.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorManager.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: isLoading ? null : () => context.go('/products'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                side: const BorderSide(color: ColorManager.grey300),
                backgroundColor: ColorManager.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: const Text('Discard'),
            ),
            SizedBox(width: 12.w),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final error = await context
                          .read<ProductsCubit>()
                          .saveProduct();
                      if (error != null && context.mounted) {
                        AppSnackBar.showError(context, error);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.mainColor,
                foregroundColor: ColorManager.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
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
                        valueColor: AlwaysStoppedAnimation<Color>(ColorManager.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/save_icon.svg',
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            ColorManager.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Text('Save Product'),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (Main Content) - Flex 2
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const GeneralInfoCard(),
              SizedBox(height: 24.h),
              const MediaCard(),
              SizedBox(height: 24.h),
              const PricingInventoryCard(),
            ],
          ),
        ),
        SizedBox(width: 24.w),
        // Right Column (Side Content) - Flex 1
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const ProductStatusCard(),
              SizedBox(height: 24.h),
              const OrganizationCard(),
              SizedBox(height: 24.h),
              const PreviewCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        const ProductStatusCard(),
        SizedBox(height: 24.h),
        const GeneralInfoCard(),
        SizedBox(height: 24.h),
        const MediaCard(),
        SizedBox(height: 24.h),
        const PricingInventoryCard(),
        SizedBox(height: 24.h),
        const OrganizationCard(),
        SizedBox(height: 24.h),
        const PreviewCard(),
      ],
    );
  }
}
