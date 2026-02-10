import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final double? width;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;
  final ValueChanged<String>? onChanged;
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.height,
    this.width,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60.h,
      width: width ?? 343.w,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.mainColor,
                  width: 0.8.w,
                ),
                borderRadius: BorderRadius.circular(32.r),
              ),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorManager.transparent,
                  width: 0.5.w,
                ),
                borderRadius: BorderRadius.circular(32.r),
              ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.8.w),
            borderRadius: BorderRadius.circular(32.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 0.8.w),
            borderRadius: BorderRadius.circular(32.r),
          ),
          hintStyle: hintStyle ?? TextStyles.font14LightGrayRegular,
          hintText: hintText,
          suffixIcon: suffixIcon,
          fillColor: backgroundColor ?? ColorManager.moreLighterGray,
          filled: true,
        ),
        obscureText: isObscureText ?? false,
        style: TextStyles.font14DarkBlueMedium,
        onChanged: onChanged,
        validator: (value) {
          return validator(value);
        },
      ),
    );
  }
}
