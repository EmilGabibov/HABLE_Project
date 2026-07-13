import 'package:drift/drift.dart';

import '../data/mascot_reminder_copy.dart';
import '../database/database.dart';
import '../database/tables.dart';

Future<CopyPersonalizationContext> loadCopyPersonalizationContext(
  AppDatabase db, {
  String? userId,
  DateTime? now,
}) async {
  final currentTime = now ?? DateTime.now();
  final todayStart = DateTime(
    currentTime.year,
    currentTime.month,
    currentTime.day,
  );
  final tomorrowStart = todayStart.add(const Duration(days: 1));
  final recentCutoff = currentTime.subtract(const Duration(days: 2));
  final nudgeCutoff = currentTime.subtract(const Duration(hours: 24));

  final habitQuery = db.select(db.habits)
    ..where((h) {
      final activeOnly = h.status.equalsValue(HabitStatus.active);
      if (userId == null || userId.isEmpty) {
        return activeOnly;
      }
      return h.userId.equals(userId) & activeOnly;
    });
  final activeHabits = await habitQuery.get();
  final habitIds = activeHabits.map((habit) => habit.habitId).toList();

  var longestStreak = 0;
  for (final habit in activeHabits) {
    final streak = await db.getStreak(habit.habitId);
    if (streak > longestStreak) {
      longestStreak = streak;
    }
  }

  final hasRecentSkip = habitIds.isEmpty
      ? false
      : await ((db.select(db.logs)..where(
                  (l) =>
                      l.habitId.isIn(habitIds) &
                      l.status.equalsValue(LogStatus.skipped) &
                      l.actionDate.isBiggerOrEqualValue(recentCutoff),
                ))
                .get())
            .then((rows) => rows.isNotEmpty);

  final completedTodayCount = habitIds.isEmpty
      ? 0
      : await ((db.select(db.logs)..where(
                  (l) =>
                      l.habitId.isIn(habitIds) &
                      l.status.equalsValue(LogStatus.completed) &
                      l.actionDate.isBiggerOrEqualValue(todayStart) &
                      l.actionDate.isSmallerThanValue(tomorrowStart),
                ))
                .get())
            .then((rows) => rows.length);

  final partnerSnapshots =
      await (db.select(db.partnerSnapshots)..where(
            (p) =>
                p.updatedAt.isBiggerOrEqualValue(nudgeCutoff) |
                p.hasCompletedToday.equals(true),
          ))
          .get();

  final recentNudgeCount = partnerSnapshots
      .where((partner) => partner.lastNudgeAt?.isAfter(nudgeCutoff) == true)
      .length;
  final partnerCompletionsToday = partnerSnapshots
      .where((partner) => partner.hasCompletedToday)
      .length;

  return CopyPersonalizationContext(
    hasActiveHabits: activeHabits.isNotEmpty,
    hasRecentSkip: hasRecentSkip,
    longestStreak: longestStreak,
    recentNudgeCount: recentNudgeCount,
    partnerCompletionsToday: partnerCompletionsToday,
    completedTodayCount: completedTodayCount,
  );
}
