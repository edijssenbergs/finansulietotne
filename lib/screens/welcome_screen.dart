import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import 'register_screen.dart';
import 'login_screen.dart';

// S-01: Sākumekrāns
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.m),
              Center(
                child: Text(
                  'Abono',
                  style: text.headlineMedium?.copyWith(
                    fontSize: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Center(
                child: Text(
                  'Visi tavi abonementi vienuviet.',
                  style: text.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Reģistrēties'),
              ),
              const SizedBox(height: AppSpacing.s),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Pieteikties'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}