import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';

class AddProductHeader extends StatelessWidget {
  const AddProductHeader({super.key, required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (previous, current) =>
          previous.getStatus('add_product') != current.getStatus('add_product') ||
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
                    isEditing ? 'Edit Product' : 'Add New Product',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    isEditing
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
              onPressed: isLoading ? null : () => _onSave(context),
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

  Future<void> _onSave(BuildContext context) async {
    final error = await context.read<ProductsCubit>().saveProduct();
    if (error != null && context.mounted) {
      AppSnackBar.showError(context, error);
    }
  }
}
