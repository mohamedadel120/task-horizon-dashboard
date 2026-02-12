import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/core/widgets/responsive_view.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/presentation/screens/desktop/products_desktop_view.dart';
import 'package:task_dashboard/features/products/presentation/screens/mobile/products_mobile_view.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = context.read<ProductsCubit>().state.searchQuery;
      if (_searchController.text != query) {
        _searchController.text = query;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state.searchQuery != _searchController.text) {
          _searchController.text = state.searchQuery;
          _searchController.selection =
              TextSelection.collapsed(offset: _searchController.text.length);
        }
        final deleteStatus = state.getStatus('delete_product');
        if (deleteStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Product deleted successfully');
        } else if (deleteStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('delete_product') ?? 'Failed to delete product',
          );
        }
      },
      child: BlocBuilder<ProductsCubit, ProductsState>(
        buildWhen: (prev, curr) =>
            prev.products != curr.products ||
            prev.searchQuery != curr.searchQuery ||
            prev.filterCategoryId != curr.filterCategoryId ||
            prev.filterStatus != curr.filterStatus,
        builder: (context, state) {
          if (state.searchQuery != _searchController.text) {
            _searchController.text = state.searchQuery;
            _searchController.selection =
                TextSelection.collapsed(offset: _searchController.text.length);
          }
          final uri = GoRouterState.of(context).uri;
          final q = uri.queryParameters['q'];
          if (q != null && q.isNotEmpty && state.searchQuery != q) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              context.read<ProductsCubit>().setSearchQuery(q);
              _searchController.text = q;
              _searchController.selection =
                  TextSelection.collapsed(offset: q.length);
            });
          }
          return ResponsiveView(
            mobile: ProductsMobileView(
              searchController: _searchController,
              state: state,
            ),
            desktop: ProductsDesktopView(
              searchController: _searchController,
              state: state,
            ),
          );
        },
      ),
    );
  }
}
