import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Add Category',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Create a new product category to organize your inventory.',
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorManager.textSecondary,
            ),
          ),
          SizedBox(height: 32.h),
          // Form Card
          Container(
            constraints: BoxConstraints(maxWidth: 600.w),
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: ColorManager.grey300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DashboardTextField(
                  label: 'Category Name',
                  hint: 'e.g. Summer Collection',
                  controller: _nameController,
                  required: true,
                ),
                SizedBox(height: 20.h),
                DashboardTextField(
                  label: 'Slug',
                  hint: 'e.g. summer-collection',
                  helperText: 'URL-friendly version of the name.',
                  controller: _slugController,
                ),
                SizedBox(height: 20.h),
                DashboardTextField(
                  label: 'Description',
                  hint: 'Describe this category...',
                  controller: _descriptionController,
                  maxLines: 4,
                ),
                SizedBox(height: 20.h),
                DashboardTextField(
                  label: 'Category Image URL',
                  hint: 'https://example.com/image.jpg',
                  helperText:
                      'Paste a direct link to an image (JPG, PNG, WebP).',
                  controller: _imageUrlController,
                  suffix: TextButton(
                    onPressed: () {},
                    child: const Text('Preview'),
                  ),
                ),
                SizedBox(height: 32.h),
                // Actions
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => context.go('/categories'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        side: const BorderSide(color: ColorManager.grey300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Save category
                        context.go('/categories');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.mainColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text('Create Category'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
