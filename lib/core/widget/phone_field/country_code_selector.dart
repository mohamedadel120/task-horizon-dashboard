import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:task_dashboard/core/theming/colors.dart';
import 'package:task_dashboard/core/utils/constants/assets/app_icons.dart';

class CountryCodeSelector extends StatelessWidget {
  final String selectedCountryCode;
  final VoidCallback? onPressed;

  const CountryCodeSelector({
    super.key,
    required this.selectedCountryCode,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onPressed ??
          () {
            // Handle country code selection
            // ignore: avoid_print
            print('Country code dropdown tapped');
          },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SvgPicture.asset(AppIcons.SAUDI_FLAG),
              ),
              const SizedBox(width: 8),
              Text(
                selectedCountryCode,
                style: TextStyle(
                  fontSize: 16,
                  color: ColorManager.grey800,
                  fontWeight: FontWeight.w500,
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
