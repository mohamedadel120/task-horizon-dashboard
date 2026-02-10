import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/category_card.dart';
import 'package:task_dashboard/features/categories/presentation/widgets/create_category_card.dart';
import 'package:go_router/go_router.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Organize your products into catalog groups.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/categories/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
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
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Grid
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 20.w,
            childAspectRatio: 0.95,
            children: [
              CategoryCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
                name: 'Electronics',
                description:
                    'Headphones, cameras, smart devices, and computer accessories for professionals and...',
                itemCount: 124,
                lastUpdated: '2h ago',
                onEdit: () {},
                onDelete: () {},
              ),
              CategoryCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
                name: 'Furniture',
                description:
                    'Ergonomic chairs, standing desks, and modern office storage solutions.',
                itemCount: 45,
                lastUpdated: '1d ago',
                onEdit: () {},
                onDelete: () {},
              ),
              CategoryCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b',
                name: 'Apparel',
                description:
                    'Men\'s and women\'s casual wear, activewear, and seasonal collections.',
                itemCount: 89,
                lastUpdated: '3d ago',
                onEdit: () {},
                onDelete: () {},
              ),
              CategoryCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1556911220-e15b29be8c8f',
                name: 'Home & Kitchen',
                description:
                    'Cookware, dining sets, small appliances, and kitchen organization tools.',
                itemCount: 67,
                lastUpdated: '5d ago',
                onEdit: () {},
                onDelete: () {},
              ),
              CategoryCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1461896836934-ffe607ba8211',
                name: 'Sports & Outdoors',
                description:
                    'Yoga mats, resistance bands, water bottles, and outdoor hiking equipment.',
                itemCount: 12,
                lastUpdated: '1w ago',
                onEdit: () {},
                onDelete: () {},
              ),
              const CreateCategoryCard(),
            ],
          ),
        ],
      ),
    );
  }
}
