import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/di/dependency_injection.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:task_dashboard/features/categories/presentation/screens/categories_screen.dart';
import 'package:task_dashboard/features/categories/presentation/screens/add_category_screen.dart';
import 'package:task_dashboard/features/products/presentation/screens/products_screen.dart';
import 'package:task_dashboard/features/products/presentation/screens/add_product_screen.dart';
import 'package:task_dashboard/features/layout/presentation/widgets/dashboard_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return DashboardLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/categories',
            name: 'categories',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => getIt<CategoriesCubit>()..listenToCategories(),
                child: const CategoriesScreen(),
              );
            },
          ),
          GoRoute(
            path: '/categories/add',
            name: 'add-category',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => getIt<CategoriesCubit>(),
                child: const AddCategoryScreen(),
              );
            },
          ),
          GoRoute(
            path: '/products',
            name: 'products',
            builder: (context, state) {
              return BlocProvider(
                create: (_) => getIt<ProductsCubit>()..listenToProducts(),
                child: const ProductsScreen(),
              );
            },
          ),
          GoRoute(
            path: '/products/add',
            name: 'add-product',
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => getIt<ProductsCubit>()),
                  BlocProvider(
                    create: (_) =>
                        getIt<CategoriesCubit>()..listenToCategories(),
                  ),
                ],
                child: const AddProductScreen(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
