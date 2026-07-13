import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';

void main() {
  test(
    'todays completion points can be upgraded for delayed shared bonus',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      const habitId = 'habit-1';
      final now = DateTime.now();

      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );
      await db.insertHabit(
        HabitsCompanion.insert(
          habitId: habitId,
          userId: userId,
          title: 'Hydration',
          isCustom: const Value(false),
          targetDuration: 21,
          currentDuration: 18,
          status: HabitStatus.active,
          colorHex: const Value('FF9CAF88'),
        ),
      );
      await db.insertLog(
        LogsCompanion.insert(
          logId: 'log-1',
          habitId: habitId,
          actionDate: now,
          status: LogStatus.completed,
          pointsAwarded: const Value(5),
          updatedAt: Value(now),
          isSynced: const Value(false),
        ),
      );

      await db.upgradeTodaysCompletionPoints(habitId, 10);

      final log = await db.getTodaysLog(habitId);
      expect(log, isNotNull);
      expect(log!.pointsAwarded, 10);
    },
  );
}
