import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/services/first_run_quote_gate.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('first-run quote splash only shows once per user', () async {
    FlutterSecureStoragePlatform.instance = TestFlutterSecureStoragePlatform(
      {},
    );
    const storage = FlutterSecureStorage();

    expect(
      await shouldShowFirstRunQuoteSplash(storage: storage, userId: 'user-1'),
      isTrue,
    );

    await markFirstRunQuoteSplashSeen(storage: storage, userId: 'user-1');

    expect(
      await shouldShowFirstRunQuoteSplash(storage: storage, userId: 'user-1'),
      isFalse,
    );
    expect(
      await shouldShowFirstRunQuoteSplash(storage: storage, userId: 'user-2'),
      isTrue,
    );
  });

  test('macOS first-run quote flag never accesses secure storage', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStoragePlatform.instance = _ThrowOnAccessStoragePlatform();
    const storage = FlutterSecureStorage();

    expect(
      await shouldShowFirstRunQuoteSplash(storage: storage, userId: 'mac-user'),
      isTrue,
    );
    await markFirstRunQuoteSplashSeen(storage: storage, userId: 'mac-user');
    expect(
      await shouldShowFirstRunQuoteSplash(storage: storage, userId: 'mac-user'),
      isFalse,
    );
  });
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
