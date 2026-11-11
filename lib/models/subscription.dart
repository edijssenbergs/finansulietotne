// Viens abonements
class Subscription {
  final String name;
  final double amount;
  final DateTime nextPayment;
  final bool rarelyUsed;

  const Subscription({
    required this.name,
    required this.amount,
    required this.nextPayment,
    this.rarelyUsed = false,
  });

  // Izveido kopiju ar mainītām vērtībām
  Subscription copyWith({
    String? name,
    double? amount,
    DateTime? nextPayment,
    bool? rarelyUsed,
  }) {
    return Subscription(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      nextPayment: nextPayment ?? this.nextPayment,
      rarelyUsed: rarelyUsed ?? this.rarelyUsed,
    );
  }

  // Cik dienu līdz nākamajam maksājumam
  int get daysLeft {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final payDay =
        DateTime(nextPayment.year, nextPayment.month, nextPayment.day);
    return payDay.difference(today).inDays;
  }

  // Summa formātā €11,99
  String get amountText => '€${amount.toStringAsFixed(2).replaceAll('.', ',')}';

  // Datums formātā 28.09.2026.
  String get dateText {
    final d = nextPayment.day.toString().padLeft(2, '0');
    final m = nextPayment.month.toString().padLeft(2, '0');
    return '$d.$m.${nextPayment.year}.';
  }
}

// Pagaidu izdomāti dati, kamēr nav servera
List<Subscription> demoSubscriptions() {
  final now = DateTime.now();
  return [
    Subscription(
      name: 'Netflix',
      amount: 11.99,
      nextPayment: now.add(const Duration(days: 2)),
    ),
    Subscription(
      name: 'Spotify',
      amount: 7.99,
      nextPayment: now.add(const Duration(days: 12)),
    ),
    Subscription(
      name: 'iCloud+',
      amount: 2.99,
      nextPayment: now.add(const Duration(days: 20)),
    ),
    Subscription(
      name: 'Sporta zāle',
      amount: 19.49,
      nextPayment: now.add(const Duration(days: 25)),
    ),
  ];
}