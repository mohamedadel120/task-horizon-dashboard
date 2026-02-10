import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';

class ProductsState extends BaseState {
  final List<Product> products;
  final String? selectedCategoryId;
  final String? selectedCategoryName;

  const ProductsState({
    required this.products,
    this.selectedCategoryId,
    this.selectedCategoryName,
    super.apiStates = const {},
  });

  @override
  ProductsState copyWith({
    List<Product>? products,
    String? selectedCategoryId,
    String? selectedCategoryName,
    Map<String, BaseApiState>? apiStates,
  }) {
    return ProductsState(
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName:
          selectedCategoryName ?? this.selectedCategoryName,
      apiStates: apiStates ?? this.apiStates,
    );
  }

  List<Object?> get props =>
      [products, selectedCategoryId, selectedCategoryName, apiStates];
}
