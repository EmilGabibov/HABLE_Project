import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/widgets/achievement_share_card.dart';

void main() {
  testWidgets('AchievementSharePreview renders without error', (tester) async {
    final user = User(
      userId: 'u1',
      username: 'TestUser',
      email: 'test@example.com',
      avatarUrl: '😀',
      levelName: 'Master',
      createdAt: DateTime(2026),
      updatedAt: DateTime(2026),
      totalScore: 420,
      isSynced: true,
    );

    final List<AchievementUnlock> achievements = [
      AchievementUnlock(
        achievementId: 'first_habit_completed',
        userId: 'u1',
        unlockedAt: DateTime(2026),
        sourceEventId: 'e1',
        isSynced: true,
        updatedAt: DateTime(2026),
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: AchievementSharePreview(
            user: user,
            achievements: achievements,
          ),
        ),
      ),
    );

    // Verify it renders the user name
    expect(find.text('TestUser'), findsWidgets);
    
    // Verify it renders the points
    expect(find.text('420'), findsOneWidget);
    
    // Verify it renders the badge
    expect(find.text('🏆 First Habit'), findsOneWidget);
    
    // Verify the Share button exists in the app bar
    expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);
  });
}
