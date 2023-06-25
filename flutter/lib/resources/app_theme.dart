import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sail/resources/app_colors.dart';
import 'package:sail/resources/app_typography.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    scaffoldBackgroundColor: AppColors.primaryBackground,

    // Bottom nav bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.secondaryBackground,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.primaryText,
      type: BottomNavigationBarType.fixed,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryBackground,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: _getTextStyle(
        fontSize: 18,
        color: AppColors.secondaryText,
      ),
    ),

    // text theme
    textTheme: TextTheme(
      titleMedium: _getTextStyle(
        fontSize: 20,
        color: AppColors.secondaryText,
      ),
      titleSmall: _getTextStyle(
        fontSize: 18,
        color: AppColors.secondaryText,
      ),
      bodyLarge: _getTextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
      ),
      bodyMedium: _getTextStyle(
        fontSize: 14,
        color: AppColors.secondaryText,
      ),
      bodySmall: _getTextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.primaryText,
      ),
    ),
  );
}

TextStyle _getTextStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w600,
  required Color color,
}) {
  return GoogleFonts.poppins(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}

class AppTheme {
  static final flatButtonStyle = TextButton.styleFrom(
    textStyle: AppTypography.labelMedium,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  static final raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: AppColors.secondaryColor,
    textStyle: AppTypography.labelMedium,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  static final outlineButtonStyle = OutlinedButton.styleFrom(
    textStyle: AppTypography.labelMedium,
    side: const BorderSide(color: AppColors.onPrimaryColor, width: 2),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );

  static final lightThemeData = ThemeData(
    useMaterial3: true,
    primarySwatch: AppColors.primarySwatch,
    splashColor: AppColors.secondaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    fontFamily: 'Urbanist',
    appBarTheme: AppBarTheme(
      // systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColors.backgroundColor,
      iconTheme: const IconThemeData(
        color: AppColors.onBackgroundColor,
      ),
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: AppColors.onPrimaryColor,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.onPrimaryColor,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.onPrimaryColor,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.onPrimaryColor,
      secondary: AppColors.secondaryColor,
      onSecondary: AppColors.onSecondaryColor,
      background: AppColors.backgroundColor,
      onBackground: AppColors.onBackgroundColor,
      error: AppColors.errorColor,
      onError: AppColors.onErrorColor,
      surface: AppColors.surfaceColor,
      onSurface: AppColors.onSurfaceColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  );

  static final darkThemeData = ThemeData(
    useMaterial3: true,
    primarySwatch: AppColors.darkPrimarySwatch,
    splashColor: AppColors.darkSecondaryColor,
    scaffoldBackgroundColor: AppColors.darkBackgroundColor,
    fontFamily: 'Urbanist',
    appBarTheme: AppBarTheme(
      // systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: AppColors.darkBackgroundColor,
      iconTheme: const IconThemeData(
        color: AppColors.darkOnBackgroundColor,
      ),
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      bodySmall: AppTypography.bodySmall.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      labelLarge: AppTypography.labelLarge.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      labelMedium: AppTypography.labelMedium.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      titleLarge: AppTypography.titleLarge.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.darkOnPrimaryColor,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.darkPrimaryColor,
      onPrimary: AppColors.darkOnPrimaryColor,
      secondary: AppColors.darkSecondaryColor,
      onSecondary: AppColors.darkOnSecondaryColor,
      background: AppColors.darkBackgroundColor,
      onBackground: AppColors.darkOnBackgroundColor,
      error: AppColors.darkErrorColor,
      onError: AppColors.darkOnErrorColor,
      surface: AppColors.darkSurfaceColor,
      onSurface: AppColors.darkOnSurfaceColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: outlineButtonStyle),
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  );
}
