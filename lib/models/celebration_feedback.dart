import 'package:flutter/material.dart';

import '../data/standard_habits.dart';
import '../database/database.dart';
import '../theme/app_theme.dart';

enum CompletionCelebrationKind {
  standard,
  streakMilestone,
  sharedCompletion,
  sharedMilestone,
}

class CompletionCelebrationSpec {
  final CompletionCelebrationKind kind;
  final String headline;
  final String supportingText;
  final String? kicker;
  final Color backgroundColor;
  final Color accentColor;
  final int particleCount;

  const CompletionCelebrationSpec({
    required this.kind,
    required this.headline,
    required this.supportingText,
    required this.backgroundColor,
    required this.accentColor,
    this.kicker,
    this.particleCount = 0,
  });
}

class HomeEncouragementSpec {
  final String emoji;
  final String title;
  final String body;
  final Color accentColor;
  final Color backgroundColor;

  const HomeEncouragementSpec({
    required this.emoji,
    required this.title,
    required this.body,
    required this.accentColor,
    required this.backgroundColor,
  });
}

int scoreAwardForCompletion({required bool sharedBonusEarned}) {
  return 5 + (sharedBonusEarned ? 5 : 0);
}

CompletionCelebrationSpec resolveCompletionCelebration({
  required Habit habit,
  required int streakCount,
  required bool sharedBonusEarned,
}) {
  final habitColor = _parseHabitColor(habit.colorHex);
  final displayTitle = habitTitleWithEmoji(habit.title);
  if (sharedBonusEarned && streakCount >= 7) {
    return CompletionCelebrationSpec(
      kind: CompletionCelebrationKind.sharedMilestone,
      kicker: 'Shared milestone',
      headline: 'Day $streakCount lands louder together.',
      supportingText:
          'You completed $displayTitle and matched your partner on a milestone streak.',
      backgroundColor: _blendHabitBackdrop(habitColor, AppTheme.deepCharcoal),
      accentColor: habitColor,
      particleCount: 24,
    );
  }
  if (sharedBonusEarned) {
    return CompletionCelebrationSpec(
      kind: CompletionCelebrationKind.sharedCompletion,
      kicker: 'Joint completion',
      headline: 'You and your partner showed up today.',
      supportingText:
          'Shared momentum makes $displayTitle feel easier to repeat tomorrow.',
      backgroundColor: _blendHabitBackdrop(habitColor, AppTheme.mutedLavender),
      accentColor: habitColor,
      particleCount: 12,
    );
  }
  if (streakCount >= 7) {
    return CompletionCelebrationSpec(
      kind: CompletionCelebrationKind.streakMilestone,
      kicker: 'Streak day $streakCount',
      headline: 'The streak is getting real.',
      supportingText:
          'You completed $displayTitle and kept a meaningful run alive today.',
      backgroundColor: _blendHabitBackdrop(habitColor, AppTheme.deepCharcoal),
      accentColor: habitColor,
      particleCount: 20,
    );
  }
  return CompletionCelebrationSpec(
    kind: CompletionCelebrationKind.standard,
    headline: 'Great job!',
    supportingText: 'You completed $displayTitle today.',
    backgroundColor: habitColor,
    accentColor: Colors.white,
  );
}

HomeEncouragementSpec resolveHomeEncouragement({
  required bool hasActiveHabits,
  required bool hasCompletedToday,
}) {
  if (!hasActiveHabits) {
    return HomeEncouragementSpec(
      emoji: '🌱',
      title: 'Start the next chapter',
      body: 'A new habit can begin small and still matter a lot.',
      accentColor: AppTheme.sageGreen,
      backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.08),
    );
  }
  if (!hasCompletedToday) {
    return HomeEncouragementSpec(
      emoji: '🚀',
      title: 'Fresh start energy',
      body:
          'A new day is still open. One honest check-in is enough to restart momentum.',
      accentColor: AppTheme.mutedLavender,
      backgroundColor: AppTheme.mutedLavender.withValues(alpha: 0.1),
    );
  }
  return HomeEncouragementSpec(
    emoji: '💬',
    title: 'Daily quote',
    body: '',
    accentColor: AppTheme.deepCharcoal,
    backgroundColor: AppTheme.sageGreen.withValues(alpha: 0.08),
  );
}

Color _parseHabitColor(String hex) {
  try {
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return AppTheme.sageGreen;
  }
}

Color _blendHabitBackdrop(Color habitColor, Color base) {
  return Color.alphaBlend(habitColor.withValues(alpha: 0.68), base);
}
