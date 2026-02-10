import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/models/category.dart';

class CategoriesState extends BaseState {
  final List<Category> categories;

  const CategoriesState({required this.categories, super.apiStates = const {}});

  @override
  CategoriesState copyWith({
    List<Category>? categories,
    Map<String, BaseApiState>? apiStates,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      apiStates: apiStates ?? this.apiStates,
    );
  }

  List<Object?> get props => [categories, apiStates];
}
