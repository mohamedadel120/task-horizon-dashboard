import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/base/cubit/base_state.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';
import 'package:task_dashboard/core/widgets/app_snackbar.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_cubit.dart';
import 'package:task_dashboard/features/categories/presentation/cubit/categories_state.dart';
import 'package:task_dashboard/core/models/category.dart';

class AddCategoryScreen extends StatefulWidget {
  final Category? category;

  const AddCategoryScreen({super.key, this.category});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  bool get _isEditMode => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    if (widget.category != null) {
      final c = widget.category!;
      _nameController.text = c.name;
      _slugController.text = c.slug;
      _descriptionController.text = c.description ?? '';
      _imageUrlController.text = c.imageUrl ?? '';
    }
  }

  void _onNameChanged() {
    if (_slugController.text.isEmpty ||
        _slugController.text == Category.generateSlug(_nameController.text)) {
      setState(() {
        _slugController.text = Category.generateSlug(_nameController.text);
      });
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final slug = _slugController.text.trim();
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim().isEmpty
        ? null
        : _imageUrlController.text.trim();

    if (_isEditMode) {
      final updated = widget.category!.copyWith(
        name: name,
        slug: slug.isEmpty ? Category.generateSlug(name) : slug,
        description: description,
        imageUrl: imageUrl,
      );
      context.read<CategoriesCubit>().updateCategory(updated);
    } else {
      context.read<CategoriesCubit>().addCategory(
            name: name,
            slug: slug,
            description: description,
            imageUrl: imageUrl,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoriesCubit, CategoriesState>(
      listener: (context, state) {
        final addStatus = state.getStatus('add_category');
        final updateStatus = state.getStatus('update_category');
        if (addStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Category created successfully!');
          if (context.mounted) context.go('/categories');
        } else if (addStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('add_category') ?? 'Failed to create category',
          );
        }
        if (updateStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, 'Category updated successfully!');
          if (context.mounted) context.go('/categories');
        } else if (updateStatus == BaseStatus.error) {
          AppSnackBar.showError(
            context,
            state.getError('update_category') ?? 'Failed to update category',
          );
        }
      },
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          final isLoading = state.getStatus('add_category') == BaseStatus.loading ||
              state.getStatus('update_category') == BaseStatus.loading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isEditMode ? 'Edit Category' : 'Add Category',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _isEditMode
                          ? 'Update category name, slug, description or image.'
                          : 'Create a new product category to organize your inventory.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                    SizedBox(height: 32.h),
                    // Form
                    // Form in single container
                    Container(
                      constraints: BoxConstraints(maxWidth: 800.w),
                      padding: EdgeInsets.all(32.w),
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: ColorManager.grey300),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DashboardTextField(
                              label: 'Category Name',
                              hint: 'e.g. Summer Collection',
                              controller: _nameController,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Category name is required';
                                }
                                if (value.trim().length < 2) {
                                  return 'Category name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            DashboardTextField(
                              label: 'Slug',
                              hint: 'e.g. summer-collection',
                              helperText: 'URL-friendly version of the name.',
                              controller: _slugController,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  final slugRegex = RegExp(
                                    r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
                                  );
                                  if (!slugRegex.hasMatch(value)) {
                                    return 'Slug can only contain lowercase letters, numbers, and hyphens';
                                  }
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            DashboardTextField(
                              label: 'Description',
                              hint: 'Describe this category...',
                              controller: _descriptionController,
                              maxLines: 4,
                            ),
                            SizedBox(height: 20.h),
                            // Image URL Input
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardTextField(
                                  label: 'Category Image URL',
                                  hint: 'https://example.com/image.jpg',
                                  helperText:
                                      'Paste a direct link to an image (JPG, PNG, WebP).',
                                  controller: _imageUrlController,
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),
                            // Actions
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => context.go('/categories'),
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 14.h,
                                    ),
                                    side: const BorderSide(
                                      color: ColorManager.grey300,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                SizedBox(width: 12.w),
                                ElevatedButton(
                                  onPressed: isLoading ? null : _saveCategory,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorManager.mainColor,
                                    foregroundColor: ColorManager.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24.w,
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 20.w,
                                          height: 20.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(ColorManager.white),
                                              ),
                                        )
                                      : Text(
                                          _isEditMode
                                              ? 'Update Category'
                                              : 'Create Category',
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
