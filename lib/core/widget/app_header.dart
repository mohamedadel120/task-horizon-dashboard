import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Alignment? alignment;
  final bool showLanguageSwitcher;

  const AppHeader({
    super.key,
    this.child,
    this.padding,
    this.alignment,
    this.showLanguageSwitcher = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showLanguageSwitcher) {
      return child ?? const SizedBox.shrink();
    }

    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final defaultAlignment = isRTL ? Alignment.topRight : Alignment.topLeft;

    return Align(
      alignment: alignment ?? defaultAlignment,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

// Convenience widget for just the language switcher
class AppLanguageSwitcher extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Alignment? alignment;

  const AppLanguageSwitcher({super.key, this.padding, this.alignment});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      padding: padding,
      alignment: alignment,
      child: const SizedBox.shrink(),
    );
  }
}
