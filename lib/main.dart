import 'package:flutter/material.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardingScreen(),
  ));
}
