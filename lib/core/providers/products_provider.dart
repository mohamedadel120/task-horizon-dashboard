import 'package:flutter/material.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/core/services/firebase_service.dart';
import 'package:task_dashboard/core/services/image_picker_service.dart';

class ProductsProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final ImagePickerService _imagePickerService = ImagePickerService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategoryFilter;
  ProductStatus? _selectedStatusFilter;

  List<Product> get products =>
      _filteredProducts.isEmpty &&
          _searchQuery.isEmpty &&
          _selectedCategoryFilter == null &&
          _selectedStatusFilter == null
      ? _products
      : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  /// Load products from Firestore
  void loadProducts() {
    _isLoading = true;
    _error = null;
    notifyListeners();

    _firebaseService.getProducts().listen(
      (products) {
        _products = products;
        _applyFilters();
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

  /// Add new product
  Future<void> addProduct({
    required String name,
    required String sku,
    String? description,
    required double price,
    required int stock,
    required String categoryId,
    String? categoryName,
    String? imageUrl,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final now = DateTime.now();
      final product = Product(
        id: '', // Will be set by Firestore
        name: name,
        sku: sku,
        description: description,
        price: price,
        stock: stock,
        categoryId: categoryId,
        categoryName: categoryName,
        imageUrl: imageUrl,
        status: stock > 0 ? ProductStatus.active : ProductStatus.outOfStock,
        createdAt: now,
        updatedAt: now,
      );

      await _firebaseService.addProduct(product);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Update existing product
  Future<void> updateProduct(Product product) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedProduct = product.copyWith(
        updatedAt: DateTime.now(),
        status: product.autoStatus, // Auto-update status based on stock
      );

      await _firebaseService.updateProduct(updatedProduct);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Delete product
  Future<void> deleteProduct(
    String id,
    String categoryId,
    String? imageUrl,
  ) async {
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

      await _firebaseService.deleteProduct(id, categoryId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by category
  void filterByCategory(String? categoryId) {
    _selectedCategoryFilter = categoryId;
    _applyFilters();
    notifyListeners();
  }

  /// Filter by status
  void filterByStatus(ProductStatus? status) {
    _selectedStatusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategoryFilter = null;
    _selectedStatusFilter = null;
    _filteredProducts = [];
    notifyListeners();
  }

  /// Apply filters
  void _applyFilters() {
    List<Product> filtered = List.from(_products);

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            product.sku.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply category filter
    if (_selectedCategoryFilter != null) {
      filtered = filtered
          .where((product) => product.categoryId == _selectedCategoryFilter)
          .toList();
    }

    // Apply status filter
    if (_selectedStatusFilter != null) {
      filtered = filtered
          .where((product) => product.status == _selectedStatusFilter)
          .toList();
    }

    _filteredProducts = filtered;
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((prod) => prod.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get products count by status
  int getProductCountByStatus(ProductStatus status) {
    return _products.where((p) => p.status == status).length;
  }

  /// Get total inventory value
  double getTotalInventoryValue() {
    return _products.fold(
      0.0,
      (sum, product) => sum + (product.price * product.stock),
    );
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
