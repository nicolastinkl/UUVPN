import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xffef233c);
  static const secondary = Color(0xff272b30);
  static const primaryBackground = Color(0xff1a1d1f);
  static const secondaryBackground = Color(0xff272b30);
  static const primaryText = Color(0xffa9aaac);
  static const secondaryText = Colors.white;
  static const primaryBtnText = Colors.white;
  static const error = Colors.red;
  static const black = Colors.black;
  static const inactiveColor = Color(0x26ffffff);
  static const transparent = Colors.transparent;
  static const ratingIconColor = Color(0xffffbe21);
  static const circleDotColor = Color(0x33ffffff);
  static const iconContainerColor = Color(0xB2272830);
  static const gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(26, 252, 252, 252),
        Color.fromARGB(0, 255, 255, 255),
      ]);

  static const primarySwatch = MaterialColor(
    0xFF15141F,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: primaryColor,
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  static const darkPrimarySwatch = MaterialColor(
    0xFF15141F,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: darkPrimaryColor,
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );

  /// Colors For the Light Theme
  static const backgroundColor = Color(0xFFFFFFFF);
  static const onBackgroundColor = Color(0xFF15141F);
  static const primaryColor = Color(0xFFFFFFFF);
  static const onPrimaryColor = Color(0xFF15141F);
  static const secondaryColor = Color(0xFFE21221);
  static const onSecondaryColor = Color(0xFFFFFFFF);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const onSurfaceColor = Color(0xFF15141F);
  static const errorColor = Color(0xFFF44336);
  static const onErrorColor = Color(0xFFFFFFFF);
  static const highEmphasized = Color(0xFFFFFFFF);
  static const mediumEmphasized = Color(0xFFBCBCBC);

  /// Colors For The dark theme
  static const darkBackgroundColor = Color(0xFF15141F);
  static const darkOnBackgroundColor = Color(0xFFFFFFFF);
  static const darkPrimaryColor = Color(0xFF15141F);
  static const darkOnPrimaryColor = Color(0xFFFFFFFF);
  static const darkSecondaryColor = Color(0xFFE21221);
  static const darkOnSecondaryColor = Color(0xFFFF8F71);
  static const darkSurfaceColor = Color(0xFF211F30);
  static const darkOnSurfaceColor = Color(0xFF211F30);
  static const darkErrorColor = Color(0xFFF44336);
  static const darkOnErrorColor = Color(0xFFFFFFFF);
  static const darkHighEmphasized = Color(0xFFFFFFFF);
  static const darkMediumEmphasized = Color(0xFFBCBCBC);
}

const appBgColor = Color(0xFF000000);
const primary = Color(0xFFFC2D55);
const secondary = Color(0xFF19D5F1);
const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
