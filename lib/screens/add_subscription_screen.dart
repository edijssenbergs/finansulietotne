import 'package:flutter/material.dart';
import '../models/subscription.dart';
import '../themes/app_theme.dart';
import '../widgets/app_text_field.dart';

// S-07: Pievienot abonementu (arī rediģēšanai, ja padots "initial")
class AddSubscriptionScreen extends StatefulWidget {
  final Subscription? initial;

  const AddSubscriptionScreen({super.key, this.initial});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();

  String? _category;

  String? _nameError;
  String? _amountError;
  String? _dateError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    final s = widget.initial;
    if (s != null) {
      _nameController.text = s.name;
      _amountController.text = s.amount.toStringAsFixed(2).replaceAll('.', ',');
      _dateController.text = s.dateText;
      _category = s.category;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // "11,99" vai "11.99" -> 11.99
  double? _parseAmount(String input) {
    final cleaned = input.trim().replaceAll('€', '').replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  // "28.09.2026" vai "28.09.2026." -> DateTime
  DateTime? _parseDate(String input) {
    final cleaned = input.trim().replaceAll(RegExp(r'\.$'), '');
    final parts = cleaned.split('.');
    if (parts.length != 3) return null;
    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    if (y < 2000 || m < 1 || m > 12 || d < 1 || d > 31) return null;
    final date = DateTime(y, m, d);
    // Pārbauda, vai datums eksistē (piemēram, nav 31.02.)
    if (date.month != m || date.day != d) return null;
    return date;
  }

  void _save() {
    final name = _nameController.text.trim();
    final amount = _parseAmount(_amountController.text);
    final date = _parseDate(_dateController.text);

    setState(() {
      _nameError = name.isEmpty ? 'Ievadi nosaukumu' : null;
      _amountError =
          (amount == null || amount <= 0) ? 'Ievadi summu, piemēram, 9,99' : null;
      _dateError = date == null ? 'Ievadi datumu formātā DD.MM.GGGG.' : null;
      _categoryError = _category == null ? 'Izvēlies kategoriju' : null;
    });

    if (_nameError != null ||
        _amountError != null ||
        _dateError != null ||
        _categoryError != null) {
      return;
    }

    Navigator.pop(
      context,
      Subscription(
        name: name,
        amount: amount!,
        nextPayment: date!,
        rarelyUsed: widget.initial?.rarelyUsed ?? false,
        category: _category!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final isEditing = widget.initial != null;

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
              Text(
                isEditing ? 'Rediģēt abonementu' : 'Pievienot abonementu',
                style: text.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.l),
              AppTextField(
                label: 'Nosaukums',
                hint: 'Piemēram, Netflix',
                controller: _nameController,
                errorText: _nameError,
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Summa',
                hint: '€0,00',
                controller: _amountController,
                errorText: _amountError,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.m),
              AppTextField(
                label: 'Norakstīšanas datums',
                hint: 'DD.MM.GGGG.',
                controller: _dateController,
                errorText: _dateError,
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: AppSpacing.m),

              // Kategorijas izvēle
              Text('Kategorija', style: text.bodyLarge),
              const SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: subscriptionCategories.map((c) {
                  final selected = _category == c;
                  return ChoiceChip(
                    label: Text(c),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    side: const BorderSide(color: AppColors.border),
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textMain,
                    ),
                    onSelected: (_) {
                      setState(() {
                        _category = c;
                        _categoryError = null;
                      });
                    },
                  );
                }).toList(),
              ),
              if (_categoryError != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    _categoryError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.l),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Saglabāt'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}