import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const EduvaApp());
}

/// Root widget of EDUVA.
///
/// Keeps the application entry point clean.
/// All business logic belongs inside features or core.
class EduvaApp extends StatelessWidget {
  const EduvaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EDUVA',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,

      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}