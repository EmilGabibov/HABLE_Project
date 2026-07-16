import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/celebration_provider.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _AuthenticatedAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState(
    isInitialized: true,
    token: 'process-token',
    userId: 'mac-user',
    username: 'Mac User',
  );
}

class _ThrowOnAccessStoragePlatform extends FlutterSecureStoragePlatform {
  Never _unexpected() => throw StateError('secure storage accessed on macOS');

  @override
  Future<bool> containsKey({
    required String key,
    required Map<String, String> options,
  }) async => _unexpected();

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) async => _unexpected();

  @override
  Future<void> deleteAll({required Map<String, String> options}) async =>
      _unexpected();

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async => _unexpected();

  @override
  Future<Map<String, String>> readAll({
    required Map<String, String> options,
  }) async => _unexpected();

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async => _unexpected();
}

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

  test(
    'macOS celebration flags use preferences instead of secure storage',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      SharedPreferences.setMockInitialValues({
        'revealed_badges_mac-user': '["already-revealed"]',
      });
      FlutterSecureStoragePlatform.instance = _ThrowOnAccessStoragePlatform();

      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          authProvider.overrideWith(_AuthenticatedAuthNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      container.listen(celebrationProvider, (_, __) {}, fireImmediately: true);
      await pumpEventQueue();
      await db.upsertAchievementUnlock(
        AchievementUnlocksCompanion.insert(
          achievementId: 'fresh-badge',
          userId: 'mac-user',
          sourceEventId: 'evt-mac',
          unlockedAt: Value(DateTime.now()),
        ),
      );
      await pumpEventQueue();
      await pumpEventQueue();

      expect(
        container.read(celebrationProvider).map((item) => item.achievementId),
        ['fresh-badge'],
      );

      await container
          .read(celebrationProvider.notifier)
          .markRevealed('fresh-badge');
      final preferences = await SharedPreferences.getInstance();
      expect(
        preferences.getString('revealed_badges_mac-user'),
        contains('fresh-badge'),
      );
    },
  );
}
