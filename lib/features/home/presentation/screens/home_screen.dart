import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Landing screen for authenticated users.
///
/// This is a placeholder screen.
/// The actual dashboard will be developed in future steps.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'Welcome to EDUVA',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}