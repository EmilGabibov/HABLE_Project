import 'package:flutter_test/flutter_test.dart';
import 'package:hable/data/mascot_reminder_copy.dart';
import 'package:hable/database/tables.dart';

void main() {
  group('MascotReminderCopyHelper', () {
    test('returns deterministic copy for the same date', () {
      final date1 = DateTime(2026, 1, 1);
      
      final copy1 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      final copy2 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      // They should be exactly the same instance/content for the same date
      expect(copy1.title, equals(copy2.title));
      expect(copy1.body, equals(copy2.body));
    });

    test('returns different variations over time', () {
      final date1 = DateTime(2026, 1, 1);
      final date2 = DateTime(2026, 1, 2);
      
      final copy1 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date1,
      );

      final copy2 = MascotReminderCopyHelper.getCopyForType(
        ReminderType.dailyHabit,
        now: date2,
      );

      // Note: Because of modulo, occasionally it could loop and be the same if the seed math hits the same index.
      // But for day 1 and day 2, seed = year*1000 + month*100 + day.
      // 20260101 % 5 = 1.  20260102 % 5 = 2.
      // So they should be different for this specific hardcoded test.
      expect(copy1.title, isNot(equals(copy2.title)));
    });
  });
}
