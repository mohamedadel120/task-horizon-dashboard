import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/core/widgets/confirm_dialog.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/create_category_card.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // Categories are loaded in AppRouter
  }

  Future<void> _deleteCategory(String id, String name, String? imageUrl) async {
    final confirmed = await ConfirmDialog.showDelete(context, itemName: name);

    if (confirmed && mounted) {
      context.read<CategoriesCubit>().deleteCategory(id, imageUrl);
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        final deleteStatus = state.getStatus('delete_category');
        if (deleteStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Category deleted successfully');
        } else if (deleteStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('delete_category') ?? 'Failed to delete category',
          );
        }
      },
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          final isLoading =
              state.getStatus('fetch_categories') == BaseStatus.loading;
          final categories = state.categories;

          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                // Loading State
                if (isLoading)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(48.h),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.mainColor,
                        ),
                      ),
                    ),
                  )
                // Empty State
                else if (categories.isEmpty)
                  Center(
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
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 14.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // Grid with data
                else
                  GridView.builder(
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
                        return const CreateCategoryCard();
                      }

                      final category = categories[index];
                      return CategoryCard(
                        imageUrl: category.imageUrl ?? '',
                        name: category.name,
                        description: category.description ?? '',
                        itemCount: category.itemCount,
                        lastUpdated: _getTimeAgo(category.updatedAt),
                        onEdit: () {
                          // TODO: Navigate to edit screen
                          AppSnackBar.showInfo(
                            context,
                            'Edit feature coming soon',
                          );
                        },
                        onDelete: () => _deleteCategory(
                          category.id,
                          category.name,
                          category.imageUrl,
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
