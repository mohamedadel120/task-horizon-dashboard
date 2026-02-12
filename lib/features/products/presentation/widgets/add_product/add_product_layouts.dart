import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/general_info_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/media_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/organization_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/preview_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/pricing_inventory_card.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/product_status_card.dart';

class AddProductDesktopLayout extends StatelessWidget {
  const AddProductDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              const GeneralInfoCard(),
              SizedBox(height: 24.h),
              const MediaCard(),
              SizedBox(height: 24.h),
              const PricingInventoryCard(),
            ],
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const ProductStatusCard(),
              SizedBox(height: 24.h),
              const OrganizationCard(),
              SizedBox(height: 24.h),
              const PreviewCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class AddProductMobileLayout extends StatelessWidget {
  const AddProductMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProductStatusCard(),
        SizedBox(height: 24.h),
        const GeneralInfoCard(),
        SizedBox(height: 24.h),
        const MediaCard(),
        SizedBox(height: 24.h),
        const PricingInventoryCard(),
        SizedBox(height: 24.h),
        const OrganizationCard(),
        SizedBox(height: 24.h),
        const PreviewCard(),
      ],
    );
  }
}
