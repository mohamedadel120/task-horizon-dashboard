import 'package:flutter/material.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String selectedCountryCode;
  final Function(String)? onChanged;
  final VoidCallback onFieldChanged;
  final bool enabled;

  const PhoneNumberInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.selectedCountryCode,
    this.onChanged,
    required this.onFieldChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: TextField(
          controller: controller,
          enabled: enabled,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.phone,
          onChanged: (value) {
            onFieldChanged();
            if (onChanged != null) onChanged!(value);
          },
          style: TextStyle(
            fontSize: 16,
            color: enabled ? ColorManager.grey800 : ColorManager.grey,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: ColorManager.grey, fontSize: 16),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 12,
            ),
          ),
        ),
      ),
    );
  }
}
