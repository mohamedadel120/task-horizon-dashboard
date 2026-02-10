import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/theming/styles.dart';

class PhoneFieldLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const PhoneFieldLabel({
    super.key,
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
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
    );
  }
}
