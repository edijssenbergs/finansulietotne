import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../themes/app_theme.dart';

// Viens paziņojums sarakstā
class _AppNotification {
  final String message;
  final String date;
  final bool warning;

  const _AppNotification({
    required this.message,
    required this.date,
    this.warning = false,
  });
}

String _daysText(int days) {
  if (days <= 0) return 'šodien';
  if (days == 1) return 'pēc 1 dienas';
  return 'pēc $days dienām';
}

String _todayText() {
  final n = DateTime.now();
  final d = n.day.toString().padLeft(2, '0');
  final m = n.month.toString().padLeft(2, '0');
  return '$d.$m.${n.year}.';
}

// S-11: Paziņojumu centrs
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  List<_AppNotification> _buildNotifications() {
    // Brīdinājumi: norakstīšana 3 dienu laikā
    final soon = sharedSubscriptions
        .where((s) => s.daysLeft >= 0 && s.daysLeft <= 3)
        .toList()
      ..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

    final list = <_AppNotification>[
      for (final s in soon)
        _AppNotification(
          message: '${s.name} abonements tiks atjaunots ${_daysText(s.daysLeft)}.',
          date: _todayText(),
          warning: true,
        ),
      // Pagaidu parauga paziņojumi, kamēr nav servera
      const _AppNotification(
        message: 'Spotify maksājums €7,99 ir veiksmīgi apmaksāts.',
        date: '05.09.2026.',
      ),
      const _AppNotification(
        message: 'iCloud+ abonementam atjaunināta summa.',
        date: '01.09.2026.',
      ),
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final items = _buildNotifications();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.l),
          children: [
            Text('Paziņojumi', style: text.headlineMedium),
            const SizedBox(height: AppSpacing.m),
            for (final n in items) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: n.warning
                      ? const Color(0xFFFFF4EE)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: n.warning
                        ? const Color(0xFFE8734A)
                        : AppColors.border,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.message,
                      style: text.bodyLarge?.copyWith(
                        color: n.warning
                            ? AppColors.warning
                            : AppColors.textMain,
                        fontWeight:
                            n.warning ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(n.date, style: text.bodySmall),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ],
        ),
      ),
    );
  }
}