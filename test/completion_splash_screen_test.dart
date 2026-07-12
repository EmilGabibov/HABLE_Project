import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/screens/completion_splash_screen.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart' show HabitStatus;
import 'package:hable/providers/quote_provider.dart';
import 'package:drift/drift.dart' show Value;

void main() {
  testWidgets('CompletionSplashScreen renders habit info and daily quote', (tester) async {
    final testHabit = Habit(
      habitId: 'test_habit_1',
      userId: 'user1',
      title: 'Morning Yoga',
      isCustom: false,
      targetDuration: 30,
      currentDuration: 30,
      status: HabitStatus.active,
      colorHex: 'FF9CAF88',
      updatedAt: DateTime.now(),
      isSynced: false,
    );

    // Provide a mocked quote
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quoteProvider.overrideWith((ref) => Future.value('Testing is believing.')),
        ],
        child: MaterialApp(
          home: CompletionSplashScreen(
            habit: testHabit,
            emoji: '🧘‍♂️',
          ),
        ),
      ),
    );

    // Initial state might be waiting for the animation to start
    await tester.pump();
    
    expect(find.text('🧘‍♂️'), findsOneWidget);
    expect(find.text('Great job!'), findsOneWidget);
    expect(find.text('You completed Morning Yoga today.'), findsOneWidget);
    expect(find.text('Tap to continue'), findsOneWidget);

    // Wait for quote future to resolve
    await tester.pumpAndSettle();

    expect(find.text('"Testing is believing."'), findsOneWidget);
  });
}
