import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../themes/app_theme.dart';

const List<String> _months = [
  'Janvāris', 'Februāris', 'Marts', 'Aprīlis', 'Maijs', 'Jūnijs',
  'Jūlijs', 'Augusts', 'Septembris', 'Oktobris', 'Novembris', 'Decembris',
];

// Katrai kategorijai sava krāsa
Color _categoryColor(String category) {
  switch (category) {
    case 'Izklaide':
      return AppColors.primary;
    case 'Veselība':
      return const Color(0xFFE8734A);
    case 'Mākonis':
      return AppColors.textSecondary;
    default:
      return AppColors.accent;
  }
}

String _money(double v) => '€${v.toStringAsFixed(2).replaceAll('.', ',')}';

// S-10: Izdevumu grafiks pa kategorijām
class ExpenseChartScreen extends StatelessWidget {
  const ExpenseChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final now = DateTime.now();

    // Summa pa kategorijām, lielākā pirmā
    final totals = <String, double>{};
    for (final s in sharedSubscriptions) {
      totals[s.category] = (totals[s.category] ?? 0) + s.amount;
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxValue = entries.isEmpty ? 1.0 : entries.first.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Izdevumu grafiks', style: text.headlineMedium),
              Text(
                '${_months[now.month - 1]} ${now.year}',
                style: text.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.l),

              if (entries.isEmpty)
                Text(
                  'Nav datu grafikam. Pievieno abonementu.',
                  style: text.bodyLarge,
                )
              else ...[
                // Stabiņu diagramma
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox(
                    height: 230,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: entries.map((e) {
                        final barHeight = 20 + (e.value / maxValue) * 160;
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _money(e.value),
                              style: text.bodySmall?.copyWith(
                                color: AppColors.textMain,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Container(
                              width: 48,
                              height: barHeight,
                              decoration: BoxDecoration(
                                color: _categoryColor(e.key),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),

                // Leģenda
                ...entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _categoryColor(e.key),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Text(e.key, style: text.bodyLarge),
                        const Spacer(),
                        Text(
                          _money(e.value),
                          style: text.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}