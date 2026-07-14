import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/social_providers.dart';
import 'package:hable/screens/profile_screen.dart';
import 'package:hable/theme/app_theme.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._authState);

  final AuthState _authState;

  @override
  AuthState build() => _authState;
}

Widget _buildApp(FriendProfileData data) {
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
      friendProfileProvider('friend-1').overrideWith((ref) async => data),
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
      await tester.pumpWidget(
        _buildApp(
          FriendProfileData(
            user: const {
              'username': 'Bob',
              'avatar_url': '🦊',
              'total_score': 135,
              'level_name': 'Trailblazer',
            },
            habits: const [
              {
                'id': 'habit-1',
                'title': 'Hydration',
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
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Friend Profile'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
      expect(find.text('135 lifetime pts'), findsOneWidget);
      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('Day 7 of 21'), findsOneWidget);
      expect(find.textContaining('Drink water across the day.'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
      await tester.pumpAndSettle();

      expect(find.text('Achievements'), findsOneWidget);
      expect(find.byIcon(Icons.workspace_premium_rounded), findsWidgets);
    },
  );
}
