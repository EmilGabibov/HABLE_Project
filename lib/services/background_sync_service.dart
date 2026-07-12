import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workmanager/workmanager.dart';

import '../database/database.dart';
import 'connectivity_service.dart';
import 'sync_service.dart';
import 'local_reminder_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final userId = inputData?['userId'] as String?;
      if (userId == null) return true; // No user to sync for

      final db = AppDatabase();
      final connectivity = ConnectivityService();
      const storage = FlutterSecureStorage();
      final localReminderService = LocalReminderService();
      await localReminderService.initialize();

      final syncService = SyncService(
        db: db,
        connectivity: connectivity,
        storage: storage,
        localReminderService: localReminderService,
      );

      // Perform a minimal background sync
      await syncService.pullDailySync(userId);

      // Dispose resources
      await db.close();

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Background sync task failed: $e');
      }
      return false; // Retry if configured
    }
  });
}

class BackgroundSyncService {
  static const String _prefetchTaskName = "com.hable.sync.prefetch";

  Future<void> initialize() async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  Future<void> scheduleReminderPrefetch(String userId, int targetHour, int targetMinute) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

    final now = DateTime.now();
    var targetTime = DateTime(now.year, now.month, now.day, targetHour, targetMinute);
    
    if (targetTime.isBefore(now)) {
      targetTime = targetTime.add(const Duration(days: 1));
    }

    // Prefetch 10 minutes before the reminder
    var prefetchTime = targetTime.subtract(const Duration(minutes: 10));
    if (prefetchTime.isBefore(now)) {
      // If subtracting 10 minutes puts it in the past, schedule it for tomorrow
      prefetchTime = prefetchTime.add(const Duration(days: 1));
    }

    final initialDelay = prefetchTime.difference(now);

    // Register a periodic task
    await Workmanager().registerPeriodicTask(
      'reminder_prefetch_$userId',
      _prefetchTaskName,
      frequency: const Duration(days: 1),
      initialDelay: initialDelay,
      inputData: {'userId': userId},
      constraints: Constraints(
        networkType: NetworkType.connected, // Only run if network is available
      ),
    );
  }

  Future<void> cancelReminderPrefetch(String userId) async {
    if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;
    await Workmanager().cancelByUniqueName('reminder_prefetch_$userId');
  }
}
