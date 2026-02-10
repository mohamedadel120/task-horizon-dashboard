import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:task_dashboard/core/base/cubit/base_cubit.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/features/products/data/repositories/product_repository.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_state.dart';
import 'package:task_dashboard/features/products/data/models/add_product_request.dart';

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
  final comparePriceController = TextEditingController();
  final tagsController = TextEditingController();
  final productTypeController = TextEditingController();

  String? _editingProductId;
  bool get isEditing => _editingProductId != null;

  ProductStatus _selectedStatus = ProductStatus.active;
  ProductStatus get selectedStatus => _selectedStatus;

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
  Future<void> addProduct(AddProductRequest request) async {
    print('=== addProduct START ===');
    final now = DateTime.now();
    final product = Product(
      id: '',
      name: request.name,
      sku: request.sku,
      categoryId: request.categoryId,
      description: request.description,
      price: request.price,
      stock: request.stock,
      imageUrl: request.imageUrl,
      comparePrice: request.comparePrice,
      tags: request.tags,
      productType: request.productType,
      status: request.status,
      createdAt: now,
      updatedAt: now,
    );

    print('=== addProduct: Product created, emitting loading ===');
    startOperation(_endpointAdd);
    print('=== addProduct: Loading emitted, calling repository ===');
    try {
      print('=== addProduct: toJson = ${product.toJson()} ===');
      final result = await _repository.addProduct(product);
      print('=== addProduct: Repository returned: $result ===');
      result.fold(
        (failure) {
          print('=== addProduct: FAILURE: ${failure.message} ===');
          failOperation(_endpointAdd, failure.message);
        },
        (data) {
          print('=== addProduct: SUCCESS, id: $data ===');
          successOperation(_endpointAdd, data: data);
        },
      );
    } catch (e, stackTrace) {
      print('=== addProduct: EXCEPTION: $e ===');
      print('=== addProduct: STACK: $stackTrace ===');
      failOperation(_endpointAdd, e.toString());
    }
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    log('updateProduct called with id: ${product.id}');
    final updated = product.copyWith(updatedAt: DateTime.now());
    log('updateProduct: emitting loading state');
    startOperation(_endpointUpdate);
    log('updateProduct: loading state emitted successfully');
    try {
      log('updateProduct: calling repository');
      final result = await _repository.updateProduct(updated);
      log('updateProduct: repository call completed');
      result.fold(
        (failure) {
          log('updateProduct: FAILURE: ${failure.message}');
          failOperation(_endpointUpdate, failure.message);
        },
        (_) {
          log('updateProduct: SUCCESS');
          successOperation(_endpointUpdate);
        },
      );
    } catch (e, stackTrace) {
      log('updateProduct: EXCEPTION: $e');
      log('updateProduct: STACK: $stackTrace');
      failOperation(_endpointUpdate, e.toString());
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    handleApiCall(
      endPoint: _endpointDelete,
      apiCall: () => _repository.deleteProduct(id),
    );
  }

  /// Fetch product by ID from API (for deep linking or refresh)
  Future<void> fetchProductById(String id) async {
    log('fetchProductById called with id: $id');
    startOperation(_endpointFetch);
    try {
      final result = await _repository.getProductById(id);
      result.fold((failure) => failOperation(_endpointFetch, failure.message), (
        product,
      ) {
        if (product != null) {
          initializeForm(product);
        }
        successOperation(_endpointFetch, data: product);
      });
    } catch (e) {
      log('fetchProductById error: $e');
      failOperation(_endpointFetch, e.toString());
    }
  }

  /// Get product by ID from local state
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

  /// Set product status
  void setStatus(ProductStatus status) {
    _selectedStatus = status;
    // Force UI rebuild if needed, though status is local to form usually
    // Using a new state property would be better if we want to be reactive
    // For now, let's emit a state change to trigger rebuilds
    emit(state.copyWith(apiStates: Map.from(state.apiStates)));
  }

  /// Initialize form with product data for editing
  void initializeForm(Product? product) {
    if (product == null) {
      clearForm();
      return;
    }

    _editingProductId = product.id;
    nameController.text = product.name;
    skuController.text = product.sku;
    descriptionController.text = product.description ?? '';
    priceController.text = product.price.toString();
    stockController.text = product.stock.toString();
    imageUrlController.text = product.imageUrl ?? '';
    comparePriceController.text = product.comparePrice != null
        ? product.comparePrice.toString()
        : '';
    tagsController.text = product.tags?.join(', ') ?? '';
    productTypeController.text = product.productType ?? '';

    _selectedStatus = product.status;

    // Set category in state
    emit(state.copyWith(selectedCategoryId: product.categoryId));
  }

  /// Submit product form with validation (Add or Update)
  /// Returns error message if validation fails, null if successful
  Future<String?> saveProduct() async {
    log(
      'saveProduct called. isEditing: $isEditing, editingId: $_editingProductId',
    );
    // Validate form
    if (formKey.currentState?.validate() != true) {
      log('saveProduct: form validation failed');
      return 'Please fill in all required fields';
    }

    // Validate category selection
    if (state.selectedCategoryId == null) {
      log('saveProduct: category not selected');
      return 'Please select a category';
    }

    try {
      if (isEditing) {
        log('saveProduct: building Product for update');
        log(
          'saveProduct: price="${priceController.text.trim()}" stock="${stockController.text.trim()}"',
        );
        final product = Product(
          id: _editingProductId!,
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
          comparePrice: comparePriceController.text.trim().isEmpty
              ? null
              : double.tryParse(comparePriceController.text.trim()),
          tags: tagsController.text.trim().isEmpty
              ? null
              : tagsController.text
                    .trim()
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
          productType: productTypeController.text.trim().isEmpty
              ? null
              : productTypeController.text.trim(),
          status: _selectedStatus,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        log('saveProduct: Product built successfully, calling updateProduct');
        await updateProduct(product);
      } else {
        // All validation passed, add product
        final request = AddProductRequest(
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
          comparePrice: comparePriceController.text.trim().isEmpty
              ? null
              : double.tryParse(comparePriceController.text.trim()),
          tags: tagsController.text.trim().isEmpty
              ? null
              : tagsController.text
                    .trim()
                    .split(',')
                    .map((e) => e.trim())
                    .toList(),
          productType: productTypeController.text.trim().isEmpty
              ? null
              : productTypeController.text.trim(),
          status: _selectedStatus,
        );
        await addProduct(request);
      }
    } catch (e, stackTrace) {
      log('saveProduct ERROR: $e');
      log('saveProduct STACK: $stackTrace');
      return 'Error: $e';
    }

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
    comparePriceController.clear();
    tagsController.clear();
    productTypeController.clear();
    _selectedStatus = ProductStatus.active;
    _editingProductId = null;
    emit(state.copyWith(selectedCategoryId: null)); // Reset category selection
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
    comparePriceController.dispose();
    tagsController.dispose();
    productTypeController.dispose();
    return super.close();
  }
}
