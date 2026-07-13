import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/widgets/user_avatar.dart';

void main() {
  testWidgets('renders deterministic emoji for default Dicebear avatar urls', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            avatarUrl: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alice',
            username: 'Alice',
          ),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsNothing);
    expect(find.text('🌱'), findsOneWidget);
  });

  testWidgets('renders emoji avatars without treating them as network images', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UserAvatar(avatarUrl: '🤖', username: 'Alice'),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsNothing);
    expect(find.text('🤖'), findsOneWidget);
  });

  testWidgets('keeps raster image urls on the image rendering path', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: UserAvatar(
            avatarUrl: 'https://example.com/avatar.png',
            username: 'Alice',
          ),
        ),
      ),
    );

    expect(find.byType(CircleAvatar), findsOneWidget);
    final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
    expect(avatar.backgroundImage, isA<NetworkImage>());
    tester.takeException();
  });
}
