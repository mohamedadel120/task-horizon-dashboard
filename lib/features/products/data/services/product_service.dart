import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_dashboard/core/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  /// Get all products as a stream
  Stream<List<Product>> getProductsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  /// Get all products once
  Future<List<Product>> getProducts() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Product.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Add new product
  Future<String> addProduct(Product product) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(product.toJson()..remove('id'));
    return docRef.id;
  }

  /// Update product
  Future<void> updateProduct(Product product) async {
    await _firestore
        .collection(_collection)
        .doc(product.id)
        .update(product.toJson()..remove('id'));
  }

  /// Delete product
  Future<void> deleteProduct(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  /// Get product by ID
  Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();

    if (!doc.exists) return null;

    return Product.fromJson({...doc.data()!, 'id': doc.id});
  }
}
