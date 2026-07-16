import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/providers/mud_tuning_provider.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/habit_card.dart';
import 'package:hable/widgets/mud_long_press_button.dart';

Habit _habit({String? description}) {
  final now = DateTime(2026, 7, 13, 9);
  return Habit(
    habitId: 'habit-1',
    title: 'Hydration',
    userId: 'user-1',
    isCustom: false,
    status: HabitStatus.active,
    colorHex: 'FF9CAF88',
    createdAt: now,
    updatedAt: now,
    isSynced: true,
    targetDuration: 21,
    currentDuration: 17,
    description: description,
  );
}

Habit _customHabit() {
  final now = DateTime(2026, 7, 13, 9);
  return Habit(
    habitId: 'custom-habit-1',
    title: '👩‍💻 Sketching',
    userId: 'user-1',
    isCustom: true,
    status: HabitStatus.active,
    colorHex: 'FF9CAF88',
    createdAt: now,
    updatedAt: now,
    isSynced: true,
    targetDuration: 21,
    currentDuration: 17,
  );
}

PartnerSnapshot _partner({
  required String id,
  required String name,
  required PartnershipRole role,
  required bool completed,
  DateTime? lastNudgeAt,
}) {
  return PartnerSnapshot(
    habitId: 'habit-1',
    partnerUserId: id,
    username: name,
    avatarUrl: '😀',
    role: role,
    currentDuration: 3,
    hasCompletedToday: completed,
    lastNudgeAt: lastNudgeAt,
    updatedAt: DateTime(2026, 7, 13, 9),
    isSynced: true,
  );
}

HabitCard _compactCard(Habit habit) {
  return HabitCard(
    habit: habit,
    userId: 'user-1',
    challengeDay: 4,
    targetDays: 21,
    progressFraction: 0.25,
    isContinuous: false,
    isCompletedToday: false,
    isSkippedToday: false,
    viewerRole: PartnershipRole.owner,
    recentNudge: null,
    streak: 5,
    resistanceCoefficient: 0.4,
    calculatedDurationMs: 600,
    partners: const [],
    hapticsEnabled: false,
    hapticProfile: MudHapticProfile.standard,
    onCompletion: () {},
    onSkip: () {},
    onNudgeTap: (_) async {},
  );
}

void main() {
  testWidgets('HabitCardShell renders the shared surface contract', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: HabitCardShell(
            semanticsLabel: 'Hydration shared shell',
            title: 'Hydration',
            topTrailing: const Text('21 days'),
            centerChild: const Text('Center content'),
            bottomChild: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(12),
              child: const Text('Bottom summary'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HabitCardShell), findsOneWidget);
    expect(find.text('Hydration'), findsOneWidget);
    expect(find.text('21 days'), findsOneWidget);
    expect(find.text('Center content'), findsOneWidget);
    expect(find.text('Bottom summary'), findsOneWidget);
  });

  testWidgets(
    'HabitCard keeps two compact shells discoverable in a mobile viewport',
    (tester) async {
      final habit = _habit(
        description:
            'A deliberately long habit description that must wrap without colliding with the completion ring.',
      );
      tester.view.physicalSize = const Size(320, 498);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                _compactCard(habit),
                const SizedBox(height: 12),
                _compactCard(habit),
              ],
            ),
          ),
        ),
      );

      final cards = find.byType(HabitCardShell);
      final firstCard = tester.getRect(cards.at(0));
      final secondCard = tester.getRect(cards.at(1));
      expect(cards, findsNWidgets(2));
      expect(firstCard.height, lessThanOrEqualTo(HabitCardShell.compactHeight));
      expect(secondCard.top, lessThan(498));
      expect(find.text('💧 Hydration'), findsNWidgets(2));
      expect(find.text('Hydration'), findsNothing);
      final card = tester.widget<Card>(find.byType(Card).first);
      expect(card.color?.a, closeTo(0.08, 0.01));
      expect(card.surfaceTintColor, Colors.transparent);
      expect(
        find.textContaining('A deliberately long habit description'),
        findsNWidgets(2),
      );
      expect(
        tester
            .widget<Container>(
              find.byKey(const Key('habit-card-progress-bar')).first,
            )
            .constraints
            ?.maxHeight,
        8,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('HabitCard compact layout stays bounded with larger text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 498);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.2)),
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: ListView(
              padding: EdgeInsets.zero,
              children: [
                _compactCard(
                  _habit(
                    description:
                        'A long description that must remain inside the compact card at larger text sizes.',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(HabitCardShell)),
      const Size(320, HabitCardShell.compactHeight),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('HabitCard preserves shared feedback and read-only states', (
    tester,
  ) async {
    final recentNudge = _partner(
      id: 'partner-1',
      name: 'Blair',
      role: PartnershipRole.partner,
      completed: false,
      lastNudgeAt: DateTime(2026, 7, 13, 8, 30),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: HabitCard(
            habit: _habit(),
            userId: 'user-1',
            challengeDay: 4,
            targetDays: 21,
            progressFraction: 0.25,
            isContinuous: false,
            isCompletedToday: false,
            isSkippedToday: false,
            viewerRole: PartnershipRole.supporter,
            recentNudge: recentNudge,
            streak: 5,
            resistanceCoefficient: 0.4,
            calculatedDurationMs: 600,
            partners: [recentNudge],
            hapticsEnabled: false,
            hapticProfile: MudHapticProfile.standard,
            onCompletion: () {},
            onSkip: () {},
            onNudgeTap: (_) async {},
            sentNudgeFeedback: QueuedNudgeFeedback(
              partnerName: 'Blair',
              queuedAt: DateTime(2026, 7, 13, 8, 35),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HabitCardShell), findsOneWidget);
    expect(find.text('Following'), findsOneWidget);
    expect(find.text('Nudged by Blair'), findsOneWidget);
    expect(find.text('Nudge queued for Blair'), findsOneWidget);
    expect(find.text('Day 4 of 21'), findsOneWidget);
    expect(find.text('🔥 5'), findsOneWidget);
  });

  testWidgets('HabitCard renders a persisted custom emoji in its ring', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: HabitCard(
            habit: _customHabit(),
            userId: 'user-1',
            challengeDay: 4,
            targetDays: 21,
            progressFraction: 0.25,
            isContinuous: false,
            isCompletedToday: true,
            isSkippedToday: false,
            viewerRole: PartnershipRole.owner,
            recentNudge: null,
            streak: 5,
            resistanceCoefficient: 0.4,
            calculatedDurationMs: 600,
            partners: const [],
            hapticsEnabled: false,
            hapticProfile: MudHapticProfile.standard,
            onCompletion: () {},
            onSkip: () {},
            onNudgeTap: (_) async {},
          ),
        ),
      ),
    );

    expect(find.text('👩‍💻'), findsOneWidget);
    expect(
      tester.getSize(find.byType(MudLongPressButton)),
      const Size(120, 120),
    );
    expect(
      tester
          .widget<Container>(find.byKey(const Key('habit-card-progress-bar')))
          .constraints
          ?.maxHeight,
      8,
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('habit-card-day-progress')))
          .style
          ?.fontSize,
      12,
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('habit-card-streak')))
          .style
          ?.fontSize,
      12,
    );
  });
}
