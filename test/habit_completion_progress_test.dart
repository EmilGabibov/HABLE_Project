import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';

void main() {
  test(
    'completeHabitDay decrements remaining days and completes at zero',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      const userId = 'user-1';
      const habitId = 'habit-1';

      await db.insertUser(
        UsersCompanion.insert(userId: userId, username: 'Alice'),
      );

      await db.insertHabit(
        HabitsCompanion.insert(
          habitId: habitId,
          userId: userId,
          title: 'Hydration',
          isCustom: const Value(false),
          targetDuration: 3,
          currentDuration: 3,
          status: HabitStatus.active,
        ),
      );

      await db.completeHabitDay(habitId);
      final afterOne = await db.getHabit(habitId);
      expect(afterOne, isNotNull);
      expect(afterOne!.currentDuration, 2);
      expect(afterOne.status, HabitStatus.active);
      expect(afterOne.isSynced, isFalse);

      await db.completeHabitDay(habitId);
      final afterTwo = await db.getHabit(habitId);
      expect(afterTwo, isNotNull);
      expect(afterTwo!.currentDuration, 1);
      expect(afterTwo.status, HabitStatus.active);

      await db.completeHabitDay(habitId);
      final afterThree = await db.getHabit(habitId);
      expect(afterThree, isNotNull);
      expect(afterThree!.currentDuration, 0);
      expect(afterThree.status, HabitStatus.completed);
    },
  );
}
