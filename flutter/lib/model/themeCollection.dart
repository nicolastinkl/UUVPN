// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:sail/resources/app_theme.dart';

class ThemeCollection extends ChangeNotifier {
  /// _colorSwatch method or function take RGB color as argument and after processing
  ///  it will return Map<int, Color> where int consist colors varients
  Map<int, Color> _colorSwatch(
    int r,
    int g,
    int b,
  ) =>
      {
        50: Color.fromRGBO(r, g, b, 0.1),
        100: Color.fromRGBO(r, g, b, 0.2),
        200: Color.fromRGBO(r, g, b, 0.3),
        300: Color.fromRGBO(r, g, b, 0.4),
        400: Color.fromRGBO(r, g, b, 0.5),
        500: Color.fromRGBO(r, g, b, 0.6),
        600: Color.fromRGBO(r, g, b, 0.7),
        700: Color.fromRGBO(r, g, b, 0.8),
        800: Color.fromRGBO(r, g, b, 0.9),
        900: Color.fromRGBO(r, g, b, 1),
      };
  bool isDarkActive = true;

  void setDarkTheme(bool value) {
    isDarkActive = value;
    notifyListeners();
  }

  ThemeData get getActiveTheme =>
      isDarkActive ? AppTheme.lightThemeData : AppTheme.darkThemeData;
}
