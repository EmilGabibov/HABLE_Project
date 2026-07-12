import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'dart:async';
import '../database/tables.dart';

class LocalReminderService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _pluginAvailable = true;

  final _payloadStreamController = StreamController<String?>.broadcast();
  Stream<String?> get onPayloadTapped => _payloadStreamController.stream;

  LocalReminderService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  bool get supportsScheduling =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Future<void> initialize() async {
    if (_initialized || !_pluginAvailable) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    try {
      await _plugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          if (response.payload != null) {
            _payloadStreamController.add(response.payload);
          }
        },
      );
    } catch (_) {
      _pluginAvailable = false;
      return;
    }

    if (supportsScheduling) {
      tz.initializeTimeZones();
      try {
        final timezoneInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }

      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              'habit_reminders',
              'Habit reminders',
              description: 'Daily Hable reminder notifications',
              importance: Importance.defaultImportance,
            ),
          );
    }

    _initialized = true;
  }

  Future<bool> requestPermission() async {
    if (!supportsScheduling) return false;
    await initialize();
    if (!_pluginAvailable) return false;

    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return await _plugin
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >()
                ?.requestPermissions(alert: true, badge: true, sound: true) ??
            false;
      }

      return await _plugin
              .resolvePlatformSpecificImplementation<
                MacOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }

    return false;
  }

  Future<bool> checkPermission() async {
    if (!supportsScheduling) return false;
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  Future<void> scheduleReminder({
    required String userId,
    required ReminderType type,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: _notificationIdForUserAndType(userId, type),
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'habit_reminders',
          'Habit reminders',
          channelDescription: 'Daily Hable reminder notifications',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload ?? 'home',
    );
  }

  Future<String?> getInitialPayload() async {
    if (!supportsScheduling) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      return details.notificationResponse?.payload;
    }
    return null;
  }

  Future<void> cancelReminder(String userId, ReminderType type) async {
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;
    await _plugin.cancel(id: _notificationIdForUserAndType(userId, type));
  }

  int _notificationIdForUserAndType(String userId, ReminderType type) {
    // Generate a stable hash for the user
    var hash = 17;
    for (final codeUnit in userId.codeUnits) {
      hash = 37 * hash + codeUnit;
    }
    final stableUserInt = hash & 0x7FFFFFFF;
    
    // Assign a fixed slot range base for each type
    int baseSlot;
    switch (type) {
      case ReminderType.dailyHabit:
        baseSlot = 1000;
        break;
    }
    
    // Each type gets a block of 1000 IDs to avoid conflicts
    return baseSlot + (stableUserInt % 1000);
  }
}

final localReminderServiceProvider = Provider<LocalReminderService>((ref) {
  return LocalReminderService();
});
