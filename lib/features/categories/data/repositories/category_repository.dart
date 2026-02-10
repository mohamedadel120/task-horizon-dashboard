import 'package:dartz/dartz.dart';
import 'package:task_dashboard/core/base/base_repository.dart';
import 'package:task_dashboard/core/errors/failures/failures.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/features/categories/data/services/category_service.dart';

class CategoryRepository extends BaseRepository {
  final CategoryService _service;

  CategoryRepository(this._service);

  Future<Either<GFailure, List<Category>>> getCategories() async {
    return safeCall(() => _service.getCategories());
  }

  Future<Either<GFailure, String>> addCategory(Category category) async {
    return safeCall(() => _service.addCategory(category));
  }

  Future<Either<GFailure, void>> updateCategory(Category category) async {
    return safeCall(() => _service.updateCategory(category));
  }

  Future<Either<GFailure, void>> deleteCategory(String id) async {
    return safeCall(() => _service.deleteCategory(id));
  }

  Future<Either<GFailure, Category?>> getCategoryById(String id) async {
    return safeCall(() => _service.getCategoryById(id));
  }

  Stream<List<Category>> getCategoriesStream() {
    return _service.getCategoriesStream();
  }
}
