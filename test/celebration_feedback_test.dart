import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/models/celebration_feedback.dart';

Habit _habit() {
  final now = DateTime(2026, 7, 13, 9);
  return Habit(
    habitId: 'habit-1',
    title: 'Hydration',
    userId: 'user-1',
    isCustom: false,
    targetDuration: 21,
    currentDuration: 14,
    status: HabitStatus.active,
    colorHex: 'FF9CAF88',
    createdAt: now,
    updatedAt: now,
    isSynced: true,
  );
}

void main() {
  test('shared milestone celebration resolves richer milestone copy', () {
    final spec = resolveCompletionCelebration(
      habit: _habit(),
      streakCount: 7,
      sharedBonusEarned: true,
    );

    expect(spec.kind, CompletionCelebrationKind.sharedMilestone);
    expect(spec.kicker, 'Shared milestone');
    expect(spec.particleCount, greaterThan(0));
  });

  test('standard completion resolves bounded base copy', () {
    final spec = resolveCompletionCelebration(
      habit: _habit(),
      streakCount: 2,
      sharedBonusEarned: false,
    );

    expect(spec.kind, CompletionCelebrationKind.standard);
    expect(spec.headline, 'Great job!');
    expect(spec.particleCount, 0);
  });

  test('scoreAwardForCompletion matches backend-owned local contract', () {
    expect(scoreAwardForCompletion(sharedBonusEarned: false), 5);
    expect(scoreAwardForCompletion(sharedBonusEarned: true), 10);
  });

  test('home encouragement distinguishes fresh-start empty day', () {
    final spec = resolveHomeEncouragement(
      hasActiveHabits: true,
      hasCompletedToday: false,
    );

    expect(spec.emoji, '🚀');
    expect(spec.title, 'Fresh start energy');
  });
}
