import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/responsive.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/categories_empty_state.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/categories_mobile_header.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
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
          const CategoriesMobileHeader(),
          SizedBox(height: 20.h),
          if (isLoading) _buildLoading(),
          if (!isLoading && categories.isEmpty) const CategoriesEmptyState(),
          if (!isLoading && categories.isNotEmpty) _buildList(context, categories),
        ],
      ),
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
      ],
    );
  }
}
