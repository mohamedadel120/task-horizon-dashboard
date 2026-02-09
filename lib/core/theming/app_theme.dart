import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_dashboard/core/theming/colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorManager.mainColor,
        primary: ColorManager.mainColor,
        surface: ColorManager.white,
      ),
      scaffoldBackgroundColor: ColorManager.bgLight,
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        backgroundColor: ColorManager.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: ColorManager.textPrimary),
        titleTextStyle: TextStyle(
          color: ColorManager.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: const CardThemeData(
        color: ColorManager.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: ColorManager.grey300),
        ),
      ),
    );
  }
}
