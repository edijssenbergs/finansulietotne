import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/app_text_field.dart';
import 'forgot_password_screen.dart';
import 'home_shell.dart';

// S-03: Pieteikšanās
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pieteikties', style: text.headlineMedium),
              const SizedBox(height: AppSpacing.l),
              const AppTextField(
                label: 'E-pasts',
                hint: 'vards@piemers.lv',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.m),
              const AppTextField(
                label: 'Parole',
                hint: '••••••••',
                obscureText: true,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeShell()),
                    (route) => false,
                  );
                },
                child: const Text('Pieteikties'),
              ),
              const SizedBox(height: AppSpacing.m),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Aizmirsu paroli',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}