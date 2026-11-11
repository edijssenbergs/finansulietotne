import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import '../widgets/app_text_field.dart';

// S-04: Paroles atjaunošana
class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
              Text('Paroles atjaunošana', style: text.headlineMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Nosūtīsim paroles atjaunošanas saiti uz tavu e-pastu.',
                style: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.l),
              const AppTextField(
                label: 'E-pasts',
                hint: 'vards@piemers.lv',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: () {
                  // Vēlāk šeit sūtīsim saiti uz e-pastu
                },
                child: const Text('Sūtīt saiti'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}