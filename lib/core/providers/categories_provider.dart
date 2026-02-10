import 'package:flutter/material.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/services/firebase_service.dart';
import 'package:task_dashboard/core/services/image_picker_service.dart';

class CategoriesProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePickerService _imagePickerService = ImagePickerService();

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load categories from Firestore
  void loadCategories() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _firebaseService.getCategories().listen(
      (categories) {
        _categories = categories;
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
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
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final now = DateTime.now();
      final category = Category(
        id: '', // Will be set by Firestore
        name: name,
        slug: slug.isEmpty ? Category.generateSlug(name) : slug,
        description: description,
        imageUrl: imageUrl,
        itemCount: 0,
        createdAt: now,
        updatedAt: now,
      );

      await _firebaseService.addCategory(category);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Update existing category
  Future<void> updateCategory(Category category) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedCategory = category.copyWith(updatedAt: DateTime.now());

      await _firebaseService.updateCategory(updatedCategory);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Delete category
  Future<void> deleteCategory(String id, String? imageUrl) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Delete image from storage if exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await _imagePickerService.deleteImage(imageUrl);
        } catch (e) {
          // Continue even if image deletion fails
        }
      }

      await _firebaseService.deleteCategory(id);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Get category by ID
  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
