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
  String _errorMsg = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
  }

  void _startTimer() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    _goToNext();
  }

  void _goToNext() {
    if (!mounted) return;
    try {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } catch (e, st) {
      setState(() {
        _errorMsg = "Navigation Failed: $e\n$st";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  onPressed: _goToNext,
                  child: const Text("Next >"),
                ),
                if (_errorMsg.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _errorMsg,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
