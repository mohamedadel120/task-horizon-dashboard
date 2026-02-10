import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/widgets/dashboard_text_field.dart';
import 'package:task_dashboard/features/products/presentation/cubit/products_cubit.dart';
import 'package:task_dashboard/features/products/presentation/widgets/add_product/section_card.dart';

class PricingInventoryCard extends StatelessWidget {
  const PricingInventoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return SectionCard(
      title: 'Pricing & Inventory',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DashboardTextField(
                  label: 'Base Price',
                  hint: '0.00',
                  controller: cubit.priceController,
                  required: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (double.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DashboardTextField(
                  label: 'Compare at Price',
                  hint: '0.00',
                  controller: cubit.comparePriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: DashboardTextField(
                  label: 'Quantity',
                  hint: '0',
                  controller: cubit.stockController,
                  required: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    if (int.tryParse(value) == null) return 'Invalid';
                    return null;
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: DashboardTextField(
                  label: 'SKU',
                  hint: 'e.g. PROD-001',
                  controller: cubit.skuController,
                  required: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
