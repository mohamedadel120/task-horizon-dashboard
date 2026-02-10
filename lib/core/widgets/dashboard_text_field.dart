import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class DashboardTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final int maxLines;
  final Widget? suffix;
  final bool required;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const DashboardTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.maxLines = 1,
    this.suffix,
    this.required = false,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.black,
            ),
            children: required
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: ColorManager.error),
                    ),
                  ]
                : null,
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: ColorManager.black),
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorManager.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorManager.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: ColorManager.mainColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorManager.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(color: ColorManager.error, width: 2),
            ),
          ),
        ),
        if (helperText != null) ...[
          SizedBox(height: 4.h),
          Text(
            helperText!,
            style: TextStyle(fontSize: 12.sp, color: ColorManager.black),
          ),
        ],
      ],
    );
  }
}
