import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage/test/test_flutter_secure_storage_platform.dart';
import 'package:flutter_secure_storage_platform_interface/flutter_secure_storage_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/services/first_run_quote_gate.dart';

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
}
