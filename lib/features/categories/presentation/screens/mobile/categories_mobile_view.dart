import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/create_category_card.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';

class CategoriesMobileView extends StatelessWidget {
  const CategoriesMobileView({
    super.key,
    required this.state,
    required this.getTimeAgo,
    required this.onDeleteCategory,
  });

  final CategoriesState state;
  final String Function(DateTime) getTimeAgo;
  final Future<void> Function(String id, String name, String? imageUrl) onDeleteCategory;

  @override
  Widget build(BuildContext context) {
    final padding = context.pagePadding;
    final isLoading = state.getStatus('fetch_categories') == BaseStatus.loading;
    final categories = state.categories;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 20.h),
          if (isLoading) _buildLoading(),
          if (!isLoading && categories.isEmpty) _buildEmptyState(context),
          if (!isLoading && categories.isNotEmpty) _buildList(context, categories),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Organize your products into catalog groups.',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorManager.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/categories/add'),
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.mainColor,
              foregroundColor: ColorManager.white,
              minimumSize: const Size(double.infinity, 48),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ColorManager.mainColor),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.h),
        child: Column(
          children: [
            Icon(
              Icons.category_outlined,
              size: 64.sp,
              color: ColorManager.textTertiary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Create your first category to start organizing products',
              style: TextStyle(
                fontSize: 14.sp,
                color: ColorManager.textSecondary,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.go('/categories/add'),
              icon: const Icon(Icons.add),
              label: const Text('Create Category'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.mainColor,
                foregroundColor: ColorManager.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, List<Category> categories) {
    final products = context.watch<ProductsCubit>().state.products;
    return Column(
      children: [
        ...categories.map(
          (category) {
            final productCount =
                products.where((p) => p.categoryId == category.id).length;
            return Padding(
              key: ValueKey(category.id),
              padding: EdgeInsets.only(bottom: 16.h),
              child: CategoryCard(
                imageUrl: category.imageUrl ?? '',
                name: category.name,
                description: category.description ?? '',
                itemCount: productCount,
              lastUpdated: getTimeAgo(category.updatedAt),
              onEdit: () => context.go(
                '/categories/edit/${category.id}',
                extra: category,
              ),
              onDelete: () => onDeleteCategory(
                category.id,
                category.name,
                category.imageUrl,
              ),
            ),
          );
          },
        ),
        // const CreateCategoryCard(key: ValueKey('create_category')),
      ],
    );
  }
}
