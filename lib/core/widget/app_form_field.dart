import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/theming/styles.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextAlign? textAlign;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool isDescription;
  final int? maxLines;
  final int minLines;
  final bool enabled;
  final bool showValidation;
  final String? successMessage;

  const AppFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.textAlign,
    this.isRequired = false,
    this.validator,
    this.isDescription = false,
    this.maxLines,
    this.minLines = 3,
    this.enabled = true,
    this.showValidation = false,
    this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return Column(
      crossAxisAlignment: isRTL
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Align(
          alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              text: label,
              style: TextStyles.font16BlackMedium,
              children: [
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: ColorManager.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        FormField<String>(
          validator: validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: isRTL
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  height: isDescription ? null : 46.h,
                  constraints: isDescription
                      ? const BoxConstraints(minHeight: 120)
                      : null,
                  decoration: BoxDecoration(
                    color: ColorManager.grey100,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: TextField(
                    controller: controller,
                    enabled: enabled,
                    textAlign:
                        textAlign ?? (isRTL ? TextAlign.right : TextAlign.left),
                    textDirection: isRTL
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    keyboardType: isDescription
                        ? TextInputType.multiline
                        : keyboardType,
                    obscureText: obscureText,
                    maxLines: isDescription ? (maxLines) : 1,
                    minLines: isDescription ? minLines : 1,
                    onChanged: (value) {
                      state.didChange(value);
                      if (onChanged != null) onChanged!(value);
                    },
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: enabled ? ColorManager.black : ColorManager.grey,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: ColorManager.grey600,
                        fontSize: 12.sp,
                      ),
                      prefixIcon: prefixIcon != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                right: isRTL ? 20 : 0,
                                left: isRTL ? 0 : 20,
                              ),
                              child: prefixIcon!,
                            )
                          : null,
                      suffixIcon: suffixIcon != null
                          ? Padding(
                              padding: EdgeInsets.only(
                                right: isRTL ? 20 : 0,
                                left: isRTL ? 0 : 20,
                              ),
                              child: suffixIcon!,
                            )
                          : null,
                      prefixIconConstraints: prefixIcon != null
                          ? const BoxConstraints(minWidth: 48, minHeight: 48)
                          : null,
                      suffixIconConstraints: suffixIcon != null
                          ? const BoxConstraints(minWidth: 48, minHeight: 48)
                          : null,
                    ),
                  ),
                ),
                if (state.hasError) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      state.errorText ?? '',
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                ] else if (showValidation &&
                    state.value != null &&
                    state.value!.isNotEmpty &&
                    !state.hasError) ...[
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      successMessage ?? '',
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      style: TextStyle(color: ColorManager.green, fontSize: 12),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
