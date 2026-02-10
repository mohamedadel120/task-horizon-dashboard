import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_dashboard/core/base/cubit/base_cubit.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/features/products/data/repositories/product_repository.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';

class ProductsCubit extends BaseCubit<ProductsState> {
  final ProductRepository _repository;
  StreamSubscription? _productsSubscription;

  static const String _endpointFetch = 'fetch_products';
  static const String _endpointAdd = 'add_product';
  static const String _endpointUpdate = 'update_product';
  static const String _endpointDelete = 'delete_product';

  // Form controllers for add/edit product
  final nameController = TextEditingController();
  final skuController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final imageUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  ProductsCubit(this._repository) : super(const ProductsState(products: []));

  /// Load products
  void loadProducts() {
    handleApiCall(
      endPoint: _endpointFetch,
      apiCall: () => _repository.getProducts(),
    );
  }

  /// Listen to products stream for real-time updates
  void listenToProducts() {
    _productsSubscription?.cancel();
    _productsSubscription = _repository.getProductsStream().listen(
      (products) {
        emit(state.copyWith(products: products));
      },
      onError: (error) {
        failOperation(_endpointFetch, error.toString());
      },
    );
  }

  /// Add new product
  Future<void> addProduct({
    required String name,
    required String sku,
    required String categoryId,
    String? description,
    required double price,
    required int stock,
    String? imageUrl,
  }) async {
    final now = DateTime.now();
    final product = Product(
      id: '',
      name: name,
      sku: sku,
      categoryId: categoryId,
      description: description,
      price: price,
      stock: stock,
      imageUrl: imageUrl,
      status: ProductStatus.active,
      createdAt: now,
      updatedAt: now,
    );

    handleApiCall(
      endPoint: _endpointAdd,
      apiCall: () => _repository.addProduct(product),
    );
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    final updated = product.copyWith(updatedAt: DateTime.now());

    handleApiCall(
      endPoint: _endpointUpdate,
      apiCall: () => _repository.updateProduct(updated),
    );
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    handleApiCall(
      endPoint: _endpointDelete,
      apiCall: () => _repository.deleteProduct(id),
    );
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return state.products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Set selected category for form
  void setCategory(String? categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  /// Submit product form with validation
  /// Returns error message if validation fails, null if successful
  Future<String?> submitProduct() async {
    // Validate form
    if (formKey.currentState?.validate() != true) {
      return 'Please fill in all required fields';
    }

    // Validate category selection
    if (state.selectedCategoryId == null) {
      return 'Please select a category';
    }

    // All validation passed, add product
    await addProduct(
      name: nameController.text.trim(),
      sku: skuController.text.trim(),
      categoryId: state.selectedCategoryId!,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      price: double.parse(priceController.text.trim()),
      stock: int.parse(stockController.text.trim()),
      imageUrl: imageUrlController.text.trim().isEmpty
          ? null
          : imageUrlController.text.trim(),
    );

    return null; // Success
  }

  /// Clear form fields
  void clearForm() {
    nameController.clear();
    skuController.clear();
    descriptionController.clear();
    priceController.clear();
    stockController.clear();
    imageUrlController.clear();
  }

  /// Reset form to initial state
  void resetForm() {
    clearForm();
    formKey.currentState?.reset();
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    nameController.dispose();
    skuController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    imageUrlController.dispose();
    return super.close();
  }
}
