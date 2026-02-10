import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/widget/phone_field/country_code_selector.dart';
import 'package:task_dashboard/core/widget/phone_field/phone_field_label.dart';
import 'package:task_dashboard/core/widget/phone_field/phone_number_input.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final Function(String)? onChanged;
  final String selectedCountryCode;
  final VoidCallback? onCountryCodePressed;
  final bool isRequired;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool showValidation;
  final String? successMessage;

  const AppPhoneField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.onChanged,
    this.selectedCountryCode = '+966',
    this.onCountryCodePressed,
    this.isRequired = false,
    this.validator,
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
        PhoneFieldLabel(label: label, isRequired: isRequired),
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
                  height: 46.h,
                  decoration: BoxDecoration(
                    color: ColorManager.grey100,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      children: [
                        // Country selector always on the left
                        CountryCodeSelector(
                          selectedCountryCode: selectedCountryCode,
                          onPressed: onCountryCodePressed,
                        ),
                        // Vertical divider
                        Container(
                          width: 1,
                          height: 32,
                          color: ColorManager.grey300,
                        ),
                        // Phone number input
                        Expanded(
                          child: PhoneNumberInput(
                            controller: controller,
                            hintText: hintText,
                            selectedCountryCode: selectedCountryCode,
                            onChanged: onChanged,
                            onFieldChanged: () =>
                                state.didChange(controller.text),
                            enabled: enabled,
                          ),
                        ),
                      ],
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
                      style: const TextStyle(
                        color: ColorManager.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ] else if (showValidation &&
                    state.value != null &&
                    state.value!.isNotEmpty &&
                    !state.hasError) ...[
                  const SizedBox(height: 6),
                  Text(
                    successMessage ?? '',
                    textAlign: isRTL ? TextAlign.right : TextAlign.left,
                    style: TextStyle(color: ColorManager.green, fontSize: 12),
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
