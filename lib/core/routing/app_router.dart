import 'package:go_router/go_router.dart';
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
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/categories/add',
            name: 'add-category',
            builder: (context, state) => const AddCategoryScreen(),
          ),
          GoRoute(
            path: '/products',
            name: 'products',
            builder: (context, state) => const ProductsScreen(),
          ),
          GoRoute(
            path: '/products/add',
            name: 'add-product',
            builder: (context, state) => const AddProductScreen(),
          ),
        ],
      ),
    ],
  );
}
