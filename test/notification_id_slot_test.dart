import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/services/local_reminder_service.dart';

void main() {
  group('LocalReminderService.notificationIdForSlot', () {
    test('dailyHabit maps to ID 100', () {
      expect(
        LocalReminderService.notificationIdForSlot(ReminderType.dailyHabit),
        equals(100),
      );
    });

    test('same slot always returns the same ID regardless of call order', () {
      final id1 = LocalReminderService.notificationIdForSlot(ReminderType.dailyHabit);
      final id2 = LocalReminderService.notificationIdForSlot(ReminderType.dailyHabit);
      expect(id1, equals(id2));
    });

    test('dailyHabit ID is within reserved self-habit range (100–199)', () {
      final id = LocalReminderService.notificationIdForSlot(ReminderType.dailyHabit);
      expect(id, greaterThanOrEqualTo(100));
      expect(id, lessThan(200));
    });

    test('reserved friend-activity range starts at 200 (not yet issued)', () {
      // Documenting the reserved boundary.
      // Friend-activity slot will be notificationIdForSlot(ReminderType.friendActivity) = 200
      // when that enum value is added.
      const friendActivityBase = 200;
      const dailyHabitId = 100;
      expect(dailyHabitId, lessThan(friendActivityBase),
          reason: 'self-habit and friend-activity ranges must not overlap');
    });
  });
}
