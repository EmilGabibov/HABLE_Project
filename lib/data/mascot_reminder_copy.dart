import '../database/tables.dart';

class ReminderCopy {
  final String title;
  final String body;

  const ReminderCopy(this.title, this.body);
}

class MascotReminderCopyHelper {
  static ReminderCopy getCopyForType(ReminderType type, {DateTime? now}) {
    final date = now ?? DateTime.now();
    // Deterministic seed based on the day of the year
    // This provides day-to-day variation but stays consistent during same-day re-schedules.
    final seed = date.year * 1000 + date.month * 100 + date.day;

    switch (type) {
      case ReminderType.dailyHabit:
        return _dailyHabitCopies[seed % _dailyHabitCopies.length];
    }
  }

  static const _dailyHabitCopies = [
    ReminderCopy('Hable time!', 'Open Hable and check today\'s habits.'),
    ReminderCopy('Your daily check-in', 'Take a moment for your habits.'),
    ReminderCopy('Stay on track', 'Don\'t forget your daily habits!'),
    ReminderCopy('Habit time!', 'Let\'s get those habits done.'),
    ReminderCopy('A gentle nudge', 'Time to review your daily goals.'),
  ];
}
