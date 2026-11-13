import 'package:flutter/material.dart';
import '../themes/app_theme.dart';
import 'welcome_screen.dart';

// S-12: Konta iestatījumi
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Šī funkcija būs pieejama vēlāk')),
    );
  }

  // Atgriežas uz sākumekrānu
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Dzēst kontu?'),
        content: const Text(
          'Visi tavi dati tiks dzēsti. Šo darbību nevar atsaukt.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Atcelt'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Dzēst',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    _logout(context);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            Text('Konta iestatījumi', style: text.headlineMedium),
            const SizedBox(height: AppSpacing.m),
            _SettingsRow(
              label: 'Mans profils',
              onTap: () => _comingSoon(context),
            ),
            _SettingsRow(
              label: 'Lejupielādēt manus datus',
              onTap: () => _comingSoon(context),
            ),
            _SettingsRow(
              label: 'Dzēst kontu',
              color: AppColors.error,
              onTap: () => _deleteAccount(context),
            ),
            _SettingsRow(
              label: 'Iziet',
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Viena iestatījumu rinda ar bultiņu
class _SettingsRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SettingsRow({
    required this.label,
    required this.onTap,
    this.color = AppColors.textMain,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.m),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: color),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: color == AppColors.textMain
                  ? AppColors.textSecondary
                  : color,
            ),
          ],
        ),
      ),
    );
  }
}