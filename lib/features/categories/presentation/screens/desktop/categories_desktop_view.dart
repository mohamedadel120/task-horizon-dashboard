import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/categories_desktop_header.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/categories_empty_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/create_category_card.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';

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
          const CategoriesDesktopHeader(),
          SizedBox(height: 24.h),
          _buildContent(context, isLoading, categories),
        ],
      ),
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
      return const CategoriesEmptyState();
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
        final products = context.watch<ProductsCubit>().state.products;
        final productCount =
            products.where((p) => p.categoryId == category.id).length;
        return CategoryCard(
          key: ValueKey(category.id),
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
        );
      },
    );
  }

}
