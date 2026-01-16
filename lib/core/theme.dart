import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light(String accent) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: _accentColor(accent),
    );
  }

  static ThemeData dark(String accent) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _accentColor(accent),
    );
  }

  static MaterialColor _accentColor(String accent) {
    switch (accent) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}
