import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../themes/app_theme.dart';
import '../widgets/subscription_card.dart';
import 'add_subscription_screen.dart';
import 'subscription_detail_screen.dart';
import 'notifications_screen.dart';

// Četri saraksta stāvokļi
enum SubsState { loading, empty, data, error }

// S-05: Abonementu saraksts (ar S-06, S-13, S-14 stāvokļiem)
class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  SubsState _state = SubsState.data;
  final List<Subscription> _items = sharedSubscriptions;

  double get _total => _items.fold<double>(0, (sum, s) => sum + s.amount);

  String _money(double v) => '€${v.toStringAsFixed(2).replaceAll('.', ',')}';

  String get _subtitle {
    switch (_state) {
      case SubsState.loading:
        return 'Kopā šomēnes: —';
      case SubsState.empty:
        return 'Kopā šomēnes: €0,00';
      case SubsState.data:
        return 'Kopā šomēnes: ${_money(_total)}';
      case SubsState.error:
        return '';
    }
  }

  // Poga "Mēģināt vēlreiz": īsa ielāde un tad dati
  Future<void> _retry() async {
    setState(() => _state = SubsState.loading);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _state = SubsState.data);
  }

  Future<void> _addSubscription() async {
  final result = await Navigator.push<Subscription>(
    context,
    MaterialPageRoute(builder: (context) => const AddSubscriptionScreen()),
  );
  if (result == null || !mounted) return;

  setState(() {
    _items.add(result);
    // Sakārto pēc tuvākā norakstīšanas datuma
    _items.sort((a, b) => a.nextPayment.compareTo(b.nextPayment));
    _state = SubsState.data;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Abonements saglabāts')),
  );
}

  // Pagaidu pogas, lai varētu apskatīt visus 4 stāvokļus
  Widget _stateButton(String label, SubsState s) {
    return TextButton(
      onPressed: () => setState(() => _state = s),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: AppColors.primary,
          fontWeight: _state == s ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: _state == SubsState.data
          ? FloatingActionButton(
              onPressed: _addSubscription,
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_state != SubsState.error)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                  AppSpacing.s,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text('Abonementi', style: text.headlineMedium),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.notifications_none),
                          color: AppColors.primary,
                          tooltip: 'Paziņojumi',
                        ),
                      ],
                    ),
                    Text(_subtitle, style: text.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    )),
                  ],
                ),
              ),
            // Pagaidu testa pogas (vēlāk izdzēsīsim)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
              child: Wrap(
                children: [
                  _stateButton('Ielāde', SubsState.loading),
                  _stateButton('Tukšs', SubsState.empty),
                  _stateButton('Dati', SubsState.data),
                  _stateButton('Kļūda', SubsState.error),
                ],
              ),
            ),
            Expanded(child: _buildBody(text)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(TextTheme text) {
    switch (_state) {
      case SubsState.loading:
        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.l),
          itemCount: 4,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) => const SubscriptionSkeleton(),
        );

      case SubsState.empty:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tev vēl nav abonementu',
                  style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addSubscription,
                    child: const Text('Pievienot abonementu'),
                  ),
                ),
              ],
            ),
          ),
        );

      case SubsState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 40,
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  'Neizdevās ielādēt datus',
                  style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.m),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _retry,
                    child: const Text('Mēģināt vēlreiz'),
                  ),
                ),
              ],
            ),
          ),
        );

      case SubsState.data:
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.m,
            AppSpacing.l,
            88,
          ),
          itemCount: _items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.s),
          itemBuilder: (context, index) => SubscriptionCard(
            subscription: _items[index],
            onTap: () {
              var current = _items[index];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionDetailScreen(
                    subscription: current,
                    onUpdate: (updated) {
                      setState(() {
                        final i = _items.indexOf(current);
                        if (i != -1) _items[i] = updated;
                        current = updated;
                        _items.sort(
                          (a, b) => a.nextPayment.compareTo(b.nextPayment),
                        );
                      });
                    },
                    onDelete: () {
                      setState(() {
                        _items.remove(current);
                        if (_items.isEmpty) _state = SubsState.empty;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        );
    }
  }
}