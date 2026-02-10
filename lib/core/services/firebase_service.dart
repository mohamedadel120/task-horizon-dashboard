import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_dashboard/core/models/category.dart';
import 'package:task_dashboard/core/models/product.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ CATEGORIES ============

  /// Get all categories
  Stream<List<Category>> getCategories() {
    return _firestore
        .collection('categories')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList(),
        );
  }

  /// Get single category by ID
  Future<Category?> getCategoryById(String id) async {
    try {
      final doc = await _firestore.collection('categories').doc(id).get();
      if (doc.exists) {
        return Category.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get category: $e');
    }
  }

  /// Add new category
  Future<String> addCategory(Category category) async {
    try {
      final docRef = await _firestore
          .collection('categories')
          .add(category.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  /// Update category
  Future<void> updateCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toJson());
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  /// Delete category
  Future<void> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }

  /// Update category item count
  Future<void> updateCategoryItemCount(String categoryId, int count) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update({
        'itemCount': count,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update category item count: $e');
    }
  }

  // ============ PRODUCTS ============

  /// Get all products
  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  /// Get products by category
  Stream<List<Product>> getProductsByCategory(String categoryId) {
    return _firestore
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  /// Get single product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection('products').doc(id).get();
      if (doc.exists) {
        return Product.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get product: $e');
    }
  }

  /// Add new product
  Future<String> addProduct(Product product) async {
    try {
      final docRef = await _firestore
          .collection('products')
          .add(product.toJson());

      // Update category item count
      if (product.categoryId.isNotEmpty) {
        await _incrementCategoryItemCount(product.categoryId);
      }

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  /// Delete product
  Future<void> deleteProduct(String id, String categoryId) async {
    try {
      await _firestore.collection('products').doc(id).delete();

      // Decrement category item count
      if (categoryId.isNotEmpty) {
        await _decrementCategoryItemCount(categoryId);
      }
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  /// Search products by name or SKU
  Future<List<Product>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .get();

      return snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  /// Get products by status
  Stream<List<Product>> getProductsByStatus(ProductStatus status) {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: status.name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList(),
        );
  }

  // ============ HELPER METHODS ============

  /// Increment category item count
  Future<void> _incrementCategoryItemCount(String categoryId) async {
    try {
      final doc = await _firestore
          .collection('categories')
          .doc(categoryId)
          .get();
      if (doc.exists) {
        final currentCount = doc.data()?['itemCount'] ?? 0;
        await _firestore.collection('categories').doc(categoryId).update({
          'itemCount': currentCount + 1,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      // Silently fail - not critical
    }
  }

  /// Decrement category item count
  Future<void> _decrementCategoryItemCount(String categoryId) async {
    try {
      final doc = await _firestore
          .collection('categories')
          .doc(categoryId)
          .get();
      if (doc.exists) {
        final currentCount = doc.data()?['itemCount'] ?? 0;
        await _firestore.collection('categories').doc(categoryId).update({
          'itemCount': currentCount > 0 ? currentCount - 1 : 0,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      // Silently fail - not critical
    }
  }
}
