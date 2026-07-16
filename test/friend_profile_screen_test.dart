import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/social_providers.dart';
import 'package:hable/screens/profile_screen.dart';
import 'package:hable/theme/app_theme.dart';
import 'package:hable/widgets/skeletons.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._authState);

  final AuthState _authState;

  @override
  AuthState build() => _authState;
}

FriendProfileData _populatedProfile({String habitTitle = 'Hydration'}) {
  return FriendProfileData(
    user: const {
      'username': 'Bob',
      'avatar_url': '🦊',
      'total_score': 135,
      'level_name': 'Trailblazer',
    },
    habits: [
      {
        'id': 'habit-1',
        'title': habitTitle,
        'description': 'Drink water across the day.',
        'target_duration': 21,
        'current_duration': 7,
        'color_hex': 'FF9CAF88',
        'role': 'owner',
      },
    ],
    achievements: const [
      {
        'achievement_id': 'first_check_in',
        'unlocked_at': '2026-07-14T10:00:00Z',
      },
    ],
  );
}

Widget _buildApp({required Future<FriendProfileData> Function() load}) {
  return ProviderScope(
    overrides: [
      authProvider.overrideWith(
        () => _FakeAuthNotifier(
          AuthState(
            isInitialized: true,
            token: 'token',
            userId: 'viewer-1',
            username: 'Alice',
          ),
        ),
      ),
      friendProfileProvider('friend-1').overrideWith((ref) => load()),
    ],
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const ProfileScreen(userId: 'friend-1'),
    ),
  );
}

void main() {
  testWidgets(
    'friend profile shows lifetime score, safe habit summaries, and achievements',
    (tester) async {
      await tester.pumpWidget(_buildApp(load: () async => _populatedProfile()));

      await tester.pumpAndSettle();

      expect(find.text('Friend Profile'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('135 lifetime pts'), findsOneWidget);
      expect(find.text('💧 Hydration'), findsOneWidget);
      expect(find.text('Day 7 of 21'), findsOneWidget);
      expect(
        find.textContaining('Drink water across the day.'),
        findsOneWidget,
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Achievements'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_rounded), findsWidgets);
    },
  );

  testWidgets('friend profile exposes a deterministic loading state', (
    tester,
  ) async {
    final load = Completer<FriendProfileData>();
    await tester.pumpWidget(_buildApp(load: () => load.future));
    await tester.pump();

    expect(find.byType(HableSkeletonCard), findsNWidgets(3));

    load.complete(_populatedProfile());
    await tester.pumpAndSettle();
    expect(find.text('💧 Hydration'), findsOneWidget);
  });

  testWidgets('friend profile shows the empty active-habits state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(
        load: () async => FriendProfileData(
          user: const {'username': 'Bob', 'total_score': 0},
          habits: const [],
          achievements: const [],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Active Habits'), findsOneWidget);
    expect(find.text('No active habits.'), findsOneWidget);
    expect(find.text('💧 Hydration'), findsNothing);
  });

  testWidgets(
    'friend profile refresh replaces the cached profile deterministically',
    (tester) async {
      var loadCount = 0;
      final refreshed = Completer<FriendProfileData>();
      await tester.pumpWidget(
        _buildApp(
          load: () {
            loadCount += 1;
            return loadCount == 1
                ? Future.value(_populatedProfile())
                : refreshed.future;
          },
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ProfileScreen)),
      );
      container.invalidate(friendProfileProvider('friend-1'));
      await tester.pump();
      expect(loadCount, 2);
      expect(find.text('💧 Hydration'), findsOneWidget);

      refreshed.complete(_populatedProfile(habitTitle: 'Reading'));
      await tester.pumpAndSettle();
      expect(find.text('📖 Reading'), findsOneWidget);
      expect(find.text('💧 Hydration'), findsNothing);
    },
  );
}
