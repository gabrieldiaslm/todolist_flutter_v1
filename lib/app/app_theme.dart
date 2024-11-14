
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData light(MaterialColor primaryColor){
    return ThemeData(
      useMaterial3: false,
      primaryColor: primaryColor,
    );
  }
}