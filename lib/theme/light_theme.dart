import 'package:flutter/material.dart';
import 'package:sq_customer/util/app_constants.dart';

ThemeData light({Color color = const Color(0xFF34D186)}) => ThemeData(
  useMaterial3: false,
  fontFamily: AppConstants.fontFamily,
  primaryColor: color,
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFF818391),
  brightness: Brightness.light,
  hintColor: const Color(0xFF2F313F),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: color)),
  colorScheme: ColorScheme.light(primary: color, secondary: color).copyWith(background: const Color(0xFFFCFCFC)).copyWith(error: const Color(0xFFE84D4F)),
);