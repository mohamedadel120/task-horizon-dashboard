import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/create_category_card.dart';

class CategoriesDesktopView extends StatelessWidget {
  const CategoriesDesktopView({
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
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: 24.h),
          _buildContent(context, isLoading, categories),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Categories',
                style: TextStyle(
                  fontSize: 28.sp,
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
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => context.go('/categories/add'),
          icon: const Icon(Icons.add),
          label: const Text('Add Category'),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorManager.mainColor,
            foregroundColor: ColorManager.white,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool isLoading,
    List<Category> categories,
  ) {
    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(48.h),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorManager.mainColor),
          ),
        ),
      );
    }
    if (categories.isEmpty) {
      return _buildEmptyState(context);
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        childAspectRatio: 0.95,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length + 1,
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return const CreateCategoryCard(key: ValueKey('create_category'));
        }
        final category = categories[index];
        return CategoryCard(
          key: ValueKey(category.id),
          imageUrl: category.imageUrl ?? '',
          name: category.name,
          description: category.description ?? '',
          itemCount: category.itemCount,
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
        );
      },
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
}
