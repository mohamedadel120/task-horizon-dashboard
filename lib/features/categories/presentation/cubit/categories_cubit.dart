import 'dart:async';
import 'package:task_dashboard/core/base/cubit/base_cubit.dart';
import 'package:task_dashboard/core/base/image_upload_service.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/features/categories/data/repositories/category_repository.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';

class CategoriesCubit extends BaseCubit<CategoriesState> {
  final CategoryRepository _repository;
  final ImageUploadService _imageUploadService;
  StreamSubscription? _categoriesSubscription;

  static const String _endpointFetch = 'fetch_categories';
  static const String _endpointAdd = 'add_category';
  static const String _endpointUpdate = 'update_category';
  static const String _endpointDelete = 'delete_category';

  CategoriesCubit(this._repository, this._imageUploadService)
    : super(const CategoriesState(categories: []));

  /// Load categories
  void loadCategories() {
    handleApiCall(
      endPoint: _endpointFetch,
      apiCall: () => _repository.getCategories(),
    );
  }

  /// Listen to categories stream for real-time updates
  void listenToCategories() {
    _categoriesSubscription?.cancel();
    _categoriesSubscription = _repository.getCategoriesStream().listen(
      (categories) {
        emit(state.copyWith(categories: categories));
      },
      onError: (error) {
        failOperation(_endpointFetch, error.toString());
      },
    );
  }

  /// Add new category
  Future<void> addCategory({
    required String name,
    required String slug,
    String? description,
    String? imageUrl,
  }) async {
    final now = DateTime.now();
    final category = Category(
      id: '',
      name: name,
      slug: slug.isEmpty ? Category.generateSlug(name) : slug,
      description: description,
      imageUrl: imageUrl,
      itemCount: 0,
      createdAt: now,
      updatedAt: now,
    );

    handleApiCall(
      endPoint: _endpointAdd,
      apiCall: () => _repository.addCategory(category),
    );
  }

  /// Update category
  Future<void> updateCategory(Category category) async {
    final updated = category.copyWith(updatedAt: DateTime.now());

    handleApiCall(
      endPoint: _endpointUpdate,
      apiCall: () => _repository.updateCategory(updated),
    );
  }

  /// Delete category
  Future<void> deleteCategory(String id, String? imageUrl) async {
    // Delete image if exists
    if (imageUrl != null && imageUrl.isNotEmpty) {
      await _imageUploadService.deleteImage(imageUrl);
    }

    handleApiCall(
      endPoint: _endpointDelete,
      apiCall: () => _repository.deleteCategory(id),
    );
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return state.categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
