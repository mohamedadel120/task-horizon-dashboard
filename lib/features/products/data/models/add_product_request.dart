import 'package:task_dashboard/core/models/product.dart';

class AddProductRequest {
  final String name;
  final String sku;
  final String categoryId;
  final String? categoryName;
  final String? description;
  final double price;
  final int stock;
  final String? imageUrl;
  final double? comparePrice;
  final List<String>? tags;
  final String? productType;
  final ProductStatus status;

  AddProductRequest({
    required this.name,
    required this.sku,
    required this.categoryId,
    this.categoryName,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.comparePrice,
    this.tags,
    this.productType,
    this.status = ProductStatus.active,
  });
}
