import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const AbonementuApp());
}

class AbonementuApp extends StatelessWidget {
  const AbonementuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abonomentu sekotājs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}