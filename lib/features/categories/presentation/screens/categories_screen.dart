import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/core/widgets/confirm_dialog.dart';
import 'package:task_dashboard/core/widgets/responsive_view.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/features/categories/presentation/screens/desktop/categories_desktop_view.dart';
import 'package:task_dashboard/features/categories/presentation/screens/mobile/categories_mobile_view.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
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
    }
    return 'Just now';
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
          return ResponsiveView(
            mobile: CategoriesMobileView(
              state: state,
              getTimeAgo: _getTimeAgo,
              onDeleteCategory: _deleteCategory,
            ),
            desktop: CategoriesDesktopView(
              state: state,
              getTimeAgo: _getTimeAgo,
              onDeleteCategory: _deleteCategory,
            ),
          );
        },
      ),
    );
  }
}
