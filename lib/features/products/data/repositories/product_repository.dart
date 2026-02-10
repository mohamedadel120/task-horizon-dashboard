import 'package:dartz/dartz.dart';
import 'package:task_dashboard/core/base/base_repository.dart';
import 'package:task_dashboard/core/errors/failures/failures.dart';
import 'package:task_dashboard/core/models/product.dart';
import 'package:task_dashboard/features/products/data/services/product_service.dart';

class ProductRepository extends BaseRepository {
  final ProductService _service;

  ProductRepository(this._service);

  Future<Either<GFailure, List<Product>>> getProducts() async {
    return safeCall(() => _service.getProducts());
  }

  Future<Either<GFailure, String>> addProduct(Product product) async {
    return safeCall(() => _service.addProduct(product));
  }

  Future<Either<GFailure, void>> updateProduct(Product product) async {
    return safeCall(() => _service.updateProduct(product));
  }

  Future<Either<GFailure, void>> deleteProduct(String id) async {
    return safeCall(() => _service.deleteProduct(id));
  }

  Future<Either<GFailure, Product?>> getProductById(String id) async {
    return safeCall(() => _service.getProductById(id));
  }

  Stream<List<Product>> getProductsStream() {
    return _service.getProductsStream();
  }
}
