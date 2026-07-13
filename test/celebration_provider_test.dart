import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/celebration_provider.dart';
import 'package:hable/providers/database_provider.dart';

void main() {
  test(
    'celebrationProvider only reveals recent unlocks and does not replay revealed badges',
    () async {
      final storageData = <String, String>{
        'jwt_token': 'token-123',
        'user_id': 'active-user',
        'username': 'Active',
      };
      FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
        storageData,
      );
      const storage = FlutterSecureStorage();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      await db.insertUser(
        UsersCompanion.insert(userId: 'active-user', username: 'Active'),
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secureStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container.dispose);

      container.read(authProvider);
      container.listen(celebrationProvider, (_, __) {}, fireImmediately: true);
      await pumpEventQueue();
      await pumpEventQueue();

      final recentTime = DateTime.now().subtract(const Duration(hours: 2));
      final oldTime = DateTime.now().subtract(const Duration(days: 5));
      await db.upsertAchievementUnlock(
        AchievementUnlocksCompanion.insert(
          achievementId: '10_streak',
          userId: 'active-user',
          sourceEventId: 'evt-recent',
          unlockedAt: Value(recentTime),
        ),
      );
      await db.upsertAchievementUnlock(
        AchievementUnlocksCompanion.insert(
          achievementId: 'first_nudge',
          userId: 'active-user',
          sourceEventId: 'evt-old',
          unlockedAt: Value(oldTime),
        ),
      );
      await pumpEventQueue();
      await pumpEventQueue();

      expect(
        container.read(celebrationProvider).map((item) => item.achievementId),
        ['10_streak'],
      );

      await container
          .read(celebrationProvider.notifier)
          .markRevealed('10_streak');
      await db.upsertAchievementUnlock(
        AchievementUnlocksCompanion.insert(
          achievementId: '10_streak',
          userId: 'active-user',
          sourceEventId: 'evt-recent',
          unlockedAt: Value(recentTime.add(const Duration(minutes: 5))),
        ),
      );
      await pumpEventQueue();
      await pumpEventQueue();

      expect(container.read(celebrationProvider), isEmpty);
    },
  );
}
