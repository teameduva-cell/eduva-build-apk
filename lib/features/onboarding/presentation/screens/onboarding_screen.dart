import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// First screen shown to users who are not logged in.
///
/// This is a placeholder.
/// A complete onboarding flow will be added later.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 90,
              color: AppColors.primary,
            ),

            SizedBox(height: 24),

            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),

            SizedBox(height: 10),

            Text(
              AppStrings.tagline,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}