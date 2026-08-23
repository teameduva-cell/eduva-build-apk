import 'dart:async';
import 'package:flutter/material.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() {
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Release mode में भी स्क्रीन पर साफ़ एरर दिखाने के लिए
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        color: Colors.red.shade900,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(
                "🚨 FLUTTER ERROR:\n\n${details.exceptionAsString()}\n\nStack:\n${details.stack}",
                style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
              ),
            ),
          ),
        ),
      );
    };

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    runApp(const EduvaApp());
  }, (error, stack) {
    debugPrint('UNCAUGHT ZONE ERROR: $error');
  });
}

class EduvaApp extends StatelessWidget {
  const EduvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDUVA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
      ),
      home: const SplashScreen(),
    );
  }
}
