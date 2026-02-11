import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/product.dart';

class _Undefined {
  const _Undefined();
}
const _undefined = _Undefined();

class ProductsState extends BaseState {
  final List<Product> products;
  final String? selectedCategoryId;
  final String? selectedCategoryName;
  final String searchQuery;
  final String? filterCategoryId;
  final ProductStatus? filterStatus;

  const ProductsState({
    required this.products,
    this.selectedCategoryId,
    this.selectedCategoryName,
    this.searchQuery = '',
    this.filterCategoryId,
    this.filterStatus,
    super.apiStates = const {},
  });

  List<Product> get filteredProducts {
    var list = products;
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      list = list.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.sku.toLowerCase().contains(q) ||
            (p.description?.toLowerCase().contains(q) ?? false) ||
            (p.categoryName?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    final categoryId = filterCategoryId;
    if (categoryId != null && categoryId.isNotEmpty) {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }
    if (filterStatus != null) {
      list = list.where((p) => p.status == filterStatus).toList();
    }
    return list;
  }

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      (filterCategoryId != null && filterCategoryId!.isNotEmpty) ||
      filterStatus != null;

  @override
  ProductsState copyWith({
    List<Product>? products,
    String? selectedCategoryId,
    String? selectedCategoryName,
    String? searchQuery,
    Object? filterCategoryId = _undefined,
    Object? filterStatus = _undefined,
    Map<String, BaseApiState>? apiStates,
  }) {
    return ProductsState(
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName:
          selectedCategoryName ?? this.selectedCategoryName,
      searchQuery: searchQuery ?? this.searchQuery,
      filterCategoryId:
          filterCategoryId == _undefined
              ? this.filterCategoryId
              : filterCategoryId as String?,
      filterStatus:
          filterStatus == _undefined
              ? this.filterStatus
              : filterStatus as ProductStatus?,
      apiStates: apiStates ?? this.apiStates,
    );
  }

  List<Object?> get props => [
        products,
        selectedCategoryId,
        selectedCategoryName,
        searchQuery,
        filterCategoryId,
        filterStatus,
        apiStates,
      ];
}
