import 'package:get_it/get_it.dart';
import 'package:task_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:task_dashboard/features/categories/data/services/category_service.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/products/data/repositories/product_repository.dart';
import 'package:task_dashboard/features/products/data/services/product_service.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/core/base/image_upload_service.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // ============ Services ============
  getIt.registerLazySingleton(() => ImageUploadService());
  getIt.registerLazySingleton(() => CategoryService());
  getIt.registerLazySingleton(() => ProductService());

  // ============ Repositories ============
  getIt.registerLazySingleton(() => CategoryRepository(getIt()));
  getIt.registerLazySingleton(() => ProductRepository(getIt()));

  // ============ Cubits ============
  getIt.registerFactory(() => CategoriesCubit(getIt(), getIt()));
  getIt.registerFactory(() => ProductsCubit(getIt()));
}
