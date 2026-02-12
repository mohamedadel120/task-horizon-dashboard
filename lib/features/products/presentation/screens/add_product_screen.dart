import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/add_product_header.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/add_product_layouts.dart';

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
    final isDesktop = context.isDesktop;
    final padding = context.pagePadding;
    final isEditing = widget.productId != null;

    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        final addStatus = state.getStatus('add_product');
        final updateStatus = state.getStatus('update_product');

        if (addStatus == BaseStatus.success ||
            updateStatus == BaseStatus.success) {
          final cubit = context.read<ProductsCubit>();
          cubit.clearOperationStatuses(['add_product', 'update_product']);
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
                (isEditing ? 'Failed to update product' : 'Failed to create product'),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Form(
            key: context.read<ProductsCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AddProductHeader(isEditing: isEditing),
                SizedBox(height: 32.h),
                if (isDesktop)
                  const AddProductDesktopLayout()
                else
                  const AddProductMobileLayout(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
