import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../themes/app_theme.dart';
import 'add_subscription_screen.dart';

// S-08: Abonementa detaļas (ar S-09 dzēšanas dialogu)
class SubscriptionDetailScreen extends StatefulWidget {
  final Subscription subscription;
  final ValueChanged<Subscription> onUpdate;
  final VoidCallback onDelete;

  const SubscriptionDetailScreen({
    super.key,
    required this.subscription,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  late Subscription _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.subscription;
  }

  Future<void> _edit() async {
    final result = await Navigator.push<Subscription>(
      context,
      MaterialPageRoute(
        builder: (context) => AddSubscriptionScreen(initial: _sub),
      ),
    );
    if (result == null || !mounted) return;
    setState(() => _sub = result);
    widget.onUpdate(result);
  }

  void _toggleRarelyUsed(bool value) {
    final updated = _sub.copyWith(rarelyUsed: value);
    setState(() => _sub = updated);
    widget.onUpdate(updated);
  }

  // S-09: apstiprinājuma dialogs
  Future<void> _confirmDelete() async {
    final text = Theme.of(context).textTheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dzēst abonementu?',
                style: text.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Vai tiešām vēlies dzēst “${_sub.name}”? '
                'Šo darbību nevar atsaukt.',
                style: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.m),
              OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Apstiprināt'),
              ),
              const SizedBox(height: AppSpacing.s),
              OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Atcelt'),
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true || !mounted) return;
    widget.onDelete();
    Navigator.pop(context);
  }

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
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_sub.name, style: text.headlineMedium),
              const SizedBox(height: AppSpacing.l),

              // Summas kartīte
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_sub.amountText} mēnesī',
                      style: text.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Nākamais maksājums: ${_sub.dateText}',
                      style: text.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              // Slēdzis "Reti izmantots"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reti izmantots', style: text.bodyLarge),
                  Switch(
                    value: _sub.rarelyUsed,
                    onChanged: _toggleRarelyUsed,
                  ),
                ],
              ),

              const Spacer(),

              // Pogas apakšā
              ElevatedButton(
                onPressed: _edit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                child: const Text('Rediģēt'),
              ),
              const SizedBox(height: AppSpacing.s),
              OutlinedButton(
                onPressed: _confirmDelete,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Dzēst'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}