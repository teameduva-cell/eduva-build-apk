import 'package:flutter/material.dart';

/// Centralized color palette for EDUVA.
///
/// These colors are used throughout the application.
/// Widgets should prefer Theme.of(context).colorScheme
/// whenever possible.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2F5CFF);

  static const Color background = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFFF7F8FA);

  static const Color textDark = Color(0xFF1C1C1E);

  static const Color textLight = Color(0xFF8E8E93);

  static const Color error = Color(0xFFD32F2F);

  static const Color onPrimary = Color(0xFFFFFFFF);
}