import 'package:flutter/material.dart';
import 'package:task_dashboard/core/theming/colors.dart';

enum AppButtonType { primary, secondary, outline, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? borderWidth;
  final AppButtonType type;
  final double? width;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final TextDecoration? decoration;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.decoration,
    this.type = AppButtonType.primary,
    this.width,
    this.height = 50,
    this.borderRadius = 25,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    // Determine if button should be enabled
    final bool isEnabled = onPressed != null && !isLoading;

    switch (type) {
      case AppButtonType.primary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? (backgroundColor ?? ColorManager.orange)
                : ColorManager.grey300,
            disabledBackgroundColor: ColorManager.grey300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide.none,
            ),
            padding: padding,
            elevation: 0,
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.secondary:
        return ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnabled
                ? (backgroundColor ?? ColorManager.grey200)
                : ColorManager.grey300,
            disabledBackgroundColor: ColorManager.grey300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide.none,
            ),
            padding: padding,
            elevation: 0,
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.outline:
        return OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isEnabled
                  ? (borderColor ?? const Color(0xFF00BFA5))
                  : ColorManager.grey300,
              width: borderWidth ?? 1,
            ),
            disabledForegroundColor: ColorManager.grey700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
          ),
          child: _buildButtonContent(),
        );

      case AppButtonType.text:
        return TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            padding: padding,
            disabledForegroundColor: ColorManager.grey700,
          ),
          child: _buildButtonContent(),
        );
    }
  }

  Widget _buildButtonContent() {
    // Show loading indicator when isLoading is true
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getLoadingIndicatorColor(),
            ),
          ),
        ),
      );
    }

    // Show icon with text if icon is provided
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: decoration,
                color: _getTextColor(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    // Show text only
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          decoration: decoration,
          color: _getTextColor(),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Color _getLoadingIndicatorColor() {
    // If button is disabled, use grey color for loading indicator
    if (onPressed == null) {
      return ColorManager.grey700;
    }

    // Use text color if provided, otherwise use default based on button type
    if (textColor != null) return textColor!;

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        return ColorManager.white;
      case AppButtonType.outline:
        return borderColor ?? const Color(0xFF00BFA5);
      case AppButtonType.text:
        return const Color(0xFFFF8C00);
    }
  }

  Color _getTextColor() {
    // If button is disabled, return dark grey
    if (onPressed == null && !isLoading) {
      return ColorManager.grey700;
    }

    if (textColor != null) return textColor!;

    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.secondary:
        return ColorManager.white;
      case AppButtonType.outline:
        return const Color(0xFF00BFA5);
      case AppButtonType.text:
        return const Color(0xFFFF8C00);
    }
  }
}
