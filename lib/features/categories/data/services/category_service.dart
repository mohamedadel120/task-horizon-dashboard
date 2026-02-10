import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_dashboard/core/models/category.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'categories';

  /// Get all categories as a stream
  Stream<List<Category>> getCategoriesStream() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Category.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  /// Get all categories once
  Future<List<Category>> getCategories() async {
    final snapshot = await _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Category.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// Add new category
  Future<String> addCategory(Category category) async {
    final docRef = await _firestore
        .collection(_collection)
        .add(category.toJson()..remove('id'));
    return docRef.id;
  }

  /// Update category
  Future<void> updateCategory(Category category) async {
    await _firestore
        .collection(_collection)
        .doc(category.id)
        .update(category.toJson()..remove('id'));
  }

  /// Delete category
  Future<void> deleteCategory(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }

  /// Get category by ID
  Future<Category?> getCategoryById(String id) async {
    final doc = await _firestore.collection(_collection).doc(id).get();

    if (!doc.exists) return null;

    return Category.fromJson({...doc.data()!, 'id': doc.id});
  }
}
