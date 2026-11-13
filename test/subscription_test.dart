import 'package:flutter_test/flutter_test.dart';
import 'package:lietotnesprojekts/models/subscription.dart';

void main() {
  test('summa tiek rādīta ar € un komatu', () {
    final s = Subscription(
      name: 'Netflix',
      amount: 11.99,
      nextPayment: DateTime(2026, 9, 28),
    );
    expect(s.amountText, '€11,99');
    expect(s.copyWith(amount: 7.5).amountText, '€7,50');
  });

  test('datums tiek rādīts formātā DD.MM.GGGG.', () {
    final a = Subscription(
      name: 'Test',
      amount: 1,
      nextPayment: DateTime(2026, 9, 28),
    );
    final b = Subscription(
      name: 'Test',
      amount: 1,
      nextPayment: DateTime(2026, 1, 5),
    );
    expect(a.dateText, '28.09.2026.');
    expect(b.dateText, '05.01.2026.');
  });

  test('dienas līdz norakstīšanai tiek aprēķinātas pareizi', () {
    final now = DateTime.now();
    Subscription inDays(int d) => Subscription(
          name: 'Test',
          amount: 1,
          nextPayment: DateTime(now.year, now.month, now.day + d),
        );

    expect(inDays(0).daysLeft, 0);
    expect(inDays(3).daysLeft, 3);
    expect(inDays(-1).daysLeft, -1);
  });

  test('copyWith maina tikai norādīto lauku', () {
    final original = Subscription(
      name: 'Spotify',
      amount: 7.99,
      nextPayment: DateTime(2026, 12, 1),
      category: 'Izklaide',
    );
    final changed = original.copyWith(rarelyUsed: true);

    expect(changed.rarelyUsed, true);
    expect(changed.name, 'Spotify');
    expect(changed.amount, 7.99);
    expect(changed.category, 'Izklaide');
  });
}