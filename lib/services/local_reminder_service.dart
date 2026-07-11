import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalReminderService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  bool _pluginAvailable = true;

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
      await _plugin.initialize(settings: initializationSettings);
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

  Future<void> scheduleDailyReminder({
    required String userId,
    required int hour,
    required int minute,
    required String title,
    required String body,
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
      id: _notificationIdForUser(userId),
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
      payload: 'home',
    );
  }

  Future<void> cancelReminder(String userId) async {
    if (!supportsScheduling) return;
    await initialize();
    if (!_pluginAvailable) return;
    await _plugin.cancel(id: _notificationIdForUser(userId));
  }

  int _notificationIdForUser(String userId) {
    var hash = 17;
    for (final codeUnit in userId.codeUnits) {
      hash = 37 * hash + codeUnit;
    }
    return hash & 0x7fffffff;
  }
}

final localReminderServiceProvider = Provider<LocalReminderService>((ref) {
  return LocalReminderService();
});
