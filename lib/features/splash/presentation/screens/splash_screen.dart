import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    _openOnboarding();
  }

  void _openOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.logo,
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 80, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.appName,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.tagline,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _openOnboarding,
              child: const Text("Next >"),
            ),
          ],
        ),
      ),
    );
  }
}
