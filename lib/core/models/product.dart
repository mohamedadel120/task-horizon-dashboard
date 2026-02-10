import 'package:cloud_firestore/cloud_firestore.dart';

enum ProductStatus {
  active,
  outOfStock,
  discontinued,
  draft;

  String get displayName {
    switch (this) {
      case ProductStatus.active:
        return 'Active';
      case ProductStatus.outOfStock:
        return 'Out of Stock';
      case ProductStatus.discontinued:
        return 'Discontinued';
      case ProductStatus.draft:
        return 'Draft';
    }
  }
}

class Product {
  final String id;
  final String name;
  final String sku;
  final String? description;
  final double price;
  final int stock;
  final String categoryId;
  final String? categoryName;
  final String? imageUrl;
  final double? comparePrice;
  final List<String>? tags;
  final String? productType;
  final ProductStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.price,
    required this.stock,
    required this.categoryId,
    this.categoryName,
    this.imageUrl,
    this.comparePrice,
    this.tags,
    this.productType,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Product to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'stock': stock,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'imageUrl': imageUrl,
      'comparePrice': comparePrice,
      'tags': tags,
      'productType': productType,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create Product from Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      description: data['description'],
      price: (data['price'] ?? 0).toDouble(),
      stock: data['stock'] ?? 0,
      categoryId: data['categoryId'] ?? '',
      categoryName: data['categoryName'],
      imageUrl: data['imageUrl'],
      comparePrice: (data['comparePrice'] ?? 0).toDouble(),
      tags: (data['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      productType: data['productType'],
      status: ProductStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ProductStatus.active,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create Product from JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sku: json['sku'] ?? '',
      description: json['description'],
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'],
      imageUrl: json['imageUrl'],
      comparePrice: (json['comparePrice'] ?? 0).toDouble(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      productType: json['productType'],
      status: json['status'] is String
          ? ProductStatus.values.firstWhere(
              (e) => e.name == json['status'],
              orElse: () => ProductStatus.active,
            )
          : ProductStatus.active,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] is Timestamp
          ? (json['updatedAt'] as Timestamp).toDate()
          : DateTime.parse(json['updatedAt']),
    );
  }

  // Create a copy with updated fields
  Product copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    double? price,
    int? stock,
    String? categoryId,
    String? categoryName,
    String? imageUrl,
    double? comparePrice,
    List<String>? tags,
    String? productType,
    ProductStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      imageUrl: imageUrl ?? this.imageUrl,
      comparePrice: comparePrice ?? this.comparePrice,
      tags: tags ?? this.tags,
      productType: productType ?? this.productType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Auto-calculate status based on stock
  ProductStatus get autoStatus {
    if (stock <= 0) {
      return ProductStatus.outOfStock;
    }
    return ProductStatus.active;
  }
}
