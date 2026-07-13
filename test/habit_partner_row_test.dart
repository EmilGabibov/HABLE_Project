import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/habit_partner_row.dart';

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
    updatedAt: DateTime(2026),
    isSynced: true,
  );
}

void main() {
  testWidgets('HabitPartnerRow caps visible partners and shows overflow', (
    tester,
  ) async {
    final partners = [
      _partner(
        id: 'p1',
        name: 'Alex',
        role: PartnershipRole.owner,
        completed: true,
      ),
      _partner(
        id: 'p2',
        name: 'Blair',
        role: PartnershipRole.partner,
        completed: false,
      ),
      _partner(
        id: 'p3',
        name: 'Casey',
        role: PartnershipRole.partner,
        completed: true,
      ),
      _partner(
        id: 'p4',
        name: 'Devon',
        role: PartnershipRole.supporter,
        completed: false,
      ),
      _partner(
        id: 'p5',
        name: 'Elliot',
        role: PartnershipRole.supporter,
        completed: false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: partners,
              habitColor: AppTheme.sageGreen,
            ),
          ),
        ),
      ),
    );

    // Expand the row to see names and overflow
    await tester.tap(find.byType(HabitPartnerRow));
    await tester.pumpAndSettle();

    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Blair'), findsOneWidget);
    expect(find.text('Casey'), findsOneWidget);
    expect(find.text('Devon'), findsOneWidget);
    expect(find.text('Elliot'), findsNothing);
    expect(find.byKey(const Key('partner-overflow-chip')), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('owner'), findsOneWidget);
  });

  testWidgets('HabitPartnerRow separates profile and nudge actions', (
    tester,
  ) async {
    var openedProfileFor = '';
    var nudgedPartner = '';
    final partner = _partner(
      id: 'p1',
      name: 'Alex',
      role: PartnershipRole.partner,
      completed: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: [partner],
              habitColor: AppTheme.sageGreen,
              onProfileTap: (selected) {
                openedProfileFor = selected.partnerUserId;
              },
              onNudgeTap: (selected) {
                nudgedPartner = selected.partnerUserId;
              },
            ),
          ),
        ),
      ),
    );

    // Expand to interact with profiles and nudges
    await tester.tap(find.byType(HabitPartnerRow));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('partner-profile-p1')));
    await tester.pump();

    expect(openedProfileFor, 'p1');
    expect(nudgedPartner, isEmpty);

    await tester.tap(find.byKey(const Key('partner-nudge-p1')));
    await tester.pump();

    expect(openedProfileFor, 'p1');
    expect(nudgedPartner, 'p1');
  });

  testWidgets('HabitPartnerRow surfaces a recent received nudge', (
    tester,
  ) async {
    final partner = _partner(
      id: 'p1',
      name: 'Alex',
      role: PartnershipRole.partner,
      completed: false,
      lastNudgeAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: [partner],
              habitColor: AppTheme.sageGreen,
            ),
          ),
        ),
      ),
    );

    // Expand to see nudge label
    await tester.tap(find.byType(HabitPartnerRow));
    await tester.pumpAndSettle();

    expect(find.text('nudged'), findsOneWidget);
  });

  testWidgets('HabitPartnerRow shows empty state when no partners', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: const [],
              habitColor: AppTheme.sageGreen,
            ),
          ),
        ),
      ),
    );

    expect(find.text('No partners'), findsOneWidget);
  });

  testWidgets('HabitPartnerRow hides names and changes layout in compactMode', (
    tester,
  ) async {
    final partners = [
      _partner(
        id: 'p1',
        name: 'CompactAlex',
        role: PartnershipRole.owner,
        completed: true,
      ),
      _partner(
        id: 'p2',
        name: 'CompactBlair',
        role: PartnershipRole.partner,
        completed: false,
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme.copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        home: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitPartnerRow(
              partners: partners,
              habitColor: AppTheme.sageGreen,
              compactMode: true,
            ),
          ),
        ),
      ),
    );

    // Expand to verify compact layout
    await tester.tap(find.byType(HabitPartnerRow));
    await tester.pumpAndSettle();

    // Names should be hidden in compactMode
    expect(find.text('CompactAlex'), findsNothing);
    expect(find.text('CompactBlair'), findsNothing);
    
    // The avatars should still be there (verifiable by profile tap semantic key)
    expect(find.byKey(const Key('partner-profile-p1')), findsOneWidget);
    expect(find.byKey(const Key('partner-profile-p2')), findsOneWidget);
  });
}
