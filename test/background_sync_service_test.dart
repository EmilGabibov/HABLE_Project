import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/services/background_sync_service.dart';

void main() {
  test('only Android supports reminder recap prefetch scheduling', () {
    expect(
      BackgroundSyncService.shouldSchedulePrefetch(
        isWeb: false,
        isAndroid: true,
        isIOS: false,
      ),
      isTrue,
    );
    expect(
      BackgroundSyncService.shouldSchedulePrefetch(
        isWeb: false,
        isAndroid: false,
        isIOS: true,
      ),
      isFalse,
    );
    expect(
      BackgroundSyncService.shouldSchedulePrefetch(
        isWeb: true,
        isAndroid: false,
        isIOS: false,
      ),
      isFalse,
    );
  });

  test('current platform guard is safe and disabled on web', () {
    final supported = BackgroundSyncService.supportsPrefetchForCurrentPlatform;

    expect(supported, isA<bool>());
    // The browser target must return false before evaluating dart:io Platform.
    // Native host tests still exercise the getter without changing the matrix.
    if (kIsWeb) expect(supported, isFalse);
  });

  test('prefetch task identity remains stable for replacement', () {
    final service = BackgroundSyncService();

    expect(
      service.uniquePrefetchName('user-1', ReminderType.dailyHabit, 7),
      'reminder_prefetch_user-1_dailyHabit_7',
    );
  });
}
