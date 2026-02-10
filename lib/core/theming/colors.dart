import 'package:flutter/material.dart';

class ColorManager {
  // Legacy aliases kept for backward compatibility
  static const Color mainColor = Color(0xFF1560FF);
  static const Color transparent = Colors.transparent;
  static const Color secondColor = Color(0xFF94A3B8);
  static const Color lightBlue = Color(0xFFF4F8FF);
  static const Color darkBlue = Color(0xFF242424);
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFC2C2C2);
  static const Color lighterGray = Color(0xFFEDEDED);
  static const Color moreLightGray = Color(0xFFFDFDFF);
  static const Color moreLighterGray = Color(0xFFF5F5F5);
  // Primary Colors (Background) - 60%
  static const Color primary10 = Color(0xFFFFFFFF);
  static const Color primary20 = Color(0xFFFFFFFF);
  static const Color primary30 = Color(0xFFFFFFFF);
  static const Color primary50 = Color(0xFFFFFFFF);
  static const Color primary70 = Color(0xFFFFFFFF);
  static const Color primary100 = Color(0xFFFFFFFF);
  static const Color status1Background = Color(0xFFFFF7E6);
  static const Color status2Background = Color(0xFFE8F5E9);
  static const Color status4Background = Color(0xFFE3F2FD);
  static const Color status3Background = Color(0xFFFDE3E3);
  static Color status7Background = Color(0xFF8C8C8C).withOpacity(0.3);
  static const Color status1Text = Color(0xFFFFA500);
  static const Color status2Text = Color(0xFF4CAF50);
  static const Color status3Text = Color(0xFFAF4C4E);
  static const Color status4Text = Color(0xFF2196F3);
  static Color status7Text = Color(0xFF8C8C8C).withOpacity(0.7);

  // Secondary Brand Colors (Card) - 30%
  static const Color secondary10 = Color(0xFFF5F5F5);
  static const Color secondary20 = Color(0xFFF5F5F5);
  static const Color secondary30 = Color(0xFFF5F5F5);
  static const Color secondary50 = Color(0xFFF5F5F5);
  static const Color secondary70 = Color(0xFFF5F5F5);
  static const Color secondary100 = Color(0xFFF5F5F5);

  // Accent Colors (Button) - 10%  [Orange brand to match image]
  static const Color accent10 = Color(0xFFF98500);
  static const Color accent20 = Color(0xFFF98500);
  static const Color accent30 = Color(0xFFF98500);
  static const Color accent50 = Color(0xFFF98500);
  static const Color accent70 = Color(0xFFF98500);
  static const Color accent100 = Color(0xFFF98500);

  // Alternative Accent Colors (kept same hue for consistency)
  static const Color accentAlt10 = Color(0xFFF98500);
  static const Color accentAlt20 = Color(0xFFF98500);
  static const Color accentAlt30 = Color(0xFFF98500);
  static const Color accentAlt50 = Color(0xFFF98500);
  static const Color accentAlt70 = Color(0xFFF98500);
  static const Color accentAlt100 = Color(0xFFF98500);

  // Text Colors
  static const Color textLight50 = Color(0xFFFFFFFF);
  static const Color textLight70 = Color(0xFFFFFFFF);
  static const Color textLight100 = Color(0xFFFFFFFF);
  static const Color textDark50 = Color(0xFF757575);
  static const Color textDark70 = Color(0xFF000000);
  static const Color textDark100 = Color(0xFF000000);

  // Status Colors
  static const Color statusSuccess = Color(0xFF28A745);
  static const Color statusError = Color(0xFFEA3442);
  static const Color statusWarning = Color(0xFFFFC107);
  static const Color statusInfo = Color(0xFF3498DB);
  static const Color statusDanger = Color(0xFFE74C3C);
  // Light/neutral variants (with transparency)
  static const Color statusSuccessLight = Color(0x3328A745); // 20% opacity
  static const Color statusWarningLight = Color(0x33FFC107); // 20% opacity
  static const Color statusNeutral = Color(0x33D9D9D9); // 20% opacity

  // Common Usage Colors
  static const Color primaryBackground = primary100;
  static const Color secondaryBackground = secondary100;
  static const Color cardBackground = secondary50;
  static const Color primaryButton = accent50;
  static const Color secondaryButton = accentAlt50;
  static const Color primaryText = textDark100;
  static const Color secondaryText = textDark70;
  static const Color lightText = textLight100;

  // Success, Error, Warning colors
  static const Color success = statusSuccess;
  static const Color error = statusError;
  static const Color warning = statusWarning;
  static const Color info = statusInfo;
  // Background Colors
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color white = Color(0xFFFFFFFF);

  // Border Colors
  static const Color grey300 = Color(0xFFE5E7EB);
  static const Color grey200 = Color(0xFFE5E7EB);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Accent Colors
  static const Color greenLight = Color(0xFFDCFCE7);
  static const Color greenDark = Color(0xFF166534);
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color redDark = Color(0xFF991B1B);

  // Common Material Colors (mapped to app colors)
  static const Color orange = accent100; // Colors.orange replacement
  static const Color black = textDark100; // Colors.black replacement
  static const Color red = statusError; // Colors.red replacement
  static const Color green = statusSuccess; // Colors.green replacement
  static const Color blue = statusInfo; // Colors.blue replacement
  static const Color yellow = statusWarning; // Colors.yellow replacement

  // Grey shades
  static const Color grey = gray;
  static const Color grey100 = Color(0xFFF5F5F5); // Colors.grey[100]

  static const Color grey400 = Color(0xFFBDBDBD); // Colors.grey[400]
  static const Color grey500 = Color(0xFF9E9E9E); // Colors.grey[500]
  static const Color grey600 = Color(0xFF757575); // Colors.grey[600]
  static const Color grey700 = Color(0xFF616161); // Colors.grey[700]
  static const Color grey800 = Color(0xFF424242); // Colors.grey[800]
  static const Color grey900 = Color(0xFF212121); // Colors.grey[900]
}

// Extension for easy usage with opacity
extension AppColorsExtension on Color {
  Color withOpacity10() => withOpacity(0.1);
  Color withOpacity20() => withOpacity(0.2);
  Color withOpacity30() => withOpacity(0.3);
  Color withOpacity50() => withOpacity(0.5);
  Color withOpacity70() => withOpacity(0.7);
}

// Theme Configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: const MaterialColor(0xFFF98500, {
        50: Color(0xFFF98500),
        100: Color(0xFFF98500),
        200: Color(0xFFF98500),
        300: Color(0xFFF98500),
        400: Color(0xFFF98500),
        500: Color(0xFFF98500),
        600: Color(0xFFF98500),
        700: Color(0xFFF98500),
        800: Color(0xFFF98500),
        900: Color(0xFFF98500),
      }),
      scaffoldBackgroundColor: ColorManager.primaryBackground,
      cardColor: ColorManager.cardBackground,
      colorScheme: const ColorScheme.light(
        primary: ColorManager.accent100,
        secondary: ColorManager.accentAlt100,
        surface: ColorManager.secondaryBackground,
        error: ColorManager.error,
        onPrimary: ColorManager.lightText,
        onSecondary: ColorManager.primaryText,
        onSurface: ColorManager.primaryText,
        onError: ColorManager.lightText,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: ColorManager.primaryText),
        bodyMedium: TextStyle(color: ColorManager.secondaryText),
        titleLarge: TextStyle(color: ColorManager.primaryText),
        titleMedium: TextStyle(color: ColorManager.primaryText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primaryButton,
          foregroundColor: ColorManager.lightText,
        ),
      ),
      cardTheme: const CardThemeData(
        color: ColorManager.cardBackground,
        elevation: 2,
      ),
      fontFamily: 'Changa',
    );
  }
}
