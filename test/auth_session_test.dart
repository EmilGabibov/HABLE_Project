import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/habit_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThrowingReadSecureStoragePlatform extends FlutterSecureStoragePlatform {
  ThrowingReadSecureStoragePlatform({required this.writeLog});

  final List<String> writeLog;

  @override
  Future<bool> containsKey({
    required String key,
    required Map<String, String> options,
  }) async => false;

  @override
  Future<void> delete({
    required String key,
    required Map<String, String> options,
  }) async {}

  @override
  Future<void> deleteAll({required Map<String, String> options}) async {}

  @override
  Future<String?> read({
    required String key,
    required Map<String, String> options,
  }) async {
    throw Exception('keychain denied');
  }

  @override
  Future<Map<String, String>> readAll({
    required Map<String, String> options,
  }) async => const {};

  @override
  Future<void> write({
    required String key,
    required String value,
    required Map<String, String> options,
  }) async {
    writeLog.add(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test(
    'currentUserProvider resolves the authenticated user and logout hides local user state',
    () async {
      final storageData = <String, String>{
        'jwt_token': 'token-123',
        'user_id': 'active-user',
        'username': 'Active',
      };
      FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
        storageData,
      );

      final db = AppDatabase(NativeDatabase.memory());

      await db.insertUser(
        UsersCompanion.insert(userId: 'stale-user', username: 'Stale'),
      );
      await db.insertUser(
        UsersCompanion.insert(userId: 'active-user', username: 'Active'),
      );

      const storage = FlutterSecureStorage();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secureStorageProvider.overrideWithValue(storage),
        ],
      );
      AsyncValue<User?>? latestUserState;
      final currentUserSubscription = container.listen<AsyncValue<User?>>(
        currentUserProvider,
        (previous, next) => latestUserState = next,
        fireImmediately: true,
      );

      container.read(authProvider);
      await pumpEventQueue();
      await pumpEventQueue();

      final authState = container.read(authProvider);
      expect(authState.isInitialized, isTrue);
      expect(authState.isAuthenticated, isTrue);
      expect(authState.userId, 'active-user');

      final currentUser = latestUserState?.value;
      expect(currentUser, isNotNull);
      expect(currentUser!.userId, 'active-user');
      expect(currentUser.username, 'Active');

      await container.read(authProvider.notifier).logout();
      await pumpEventQueue();
      await pumpEventQueue();

      final loggedOutState = container.read(authProvider);
      expect(loggedOutState.isInitialized, isTrue);
      expect(loggedOutState.isAuthenticated, isFalse);
      expect(loggedOutState.userId, isNull);
      expect(storageData, isEmpty);

      final loggedOutUser = latestUserState?.value;
      expect(loggedOutUser, isNull);

      currentUserSubscription.close();
      container.dispose();
      await db.close();
    },
  );

  test(
    'macOS snapshot restore does not rewrite secure storage after keychain read failure',
    () async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      final writes = <String>[];
      FlutterSecureStoragePlatform.instance = ThrowingReadSecureStoragePlatform(
        writeLog: writes,
      );
      SharedPreferences.setMockInitialValues({
        'session_token_snapshot': 'snapshot-token',
        'session_user_id_snapshot': 'snapshot-user',
        'session_username_snapshot': 'Snapshot',
      });

      final db = AppDatabase(NativeDatabase.memory());
      await db.insertUser(
        UsersCompanion.insert(userId: 'snapshot-user', username: 'Snapshot'),
      );
      const storage = FlutterSecureStorage();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          secureStorageProvider.overrideWithValue(storage),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(db.close);

      container.read(authProvider);
      await pumpEventQueue();
      await pumpEventQueue();

      final authState = container.read(authProvider);
      expect(authState.isInitialized, isTrue);
      expect(authState.userId, 'snapshot-user');
      expect(authState.username, 'Snapshot');
      expect(writes, isEmpty);
    },
  );
}
