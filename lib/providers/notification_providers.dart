import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database.dart';
import '../database/tables.dart';
import '../services/local_reminder_service.dart';
import 'auth_provider.dart';
import 'database_provider.dart';

final notificationsForUserProvider =
    StreamProvider.family<List<NotificationEvent>, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchNotificationsForUser(userId);
    });

final unreadNotificationsForUserProvider =
    StreamProvider.family<List<NotificationEvent>, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchUnreadNotificationsForUser(userId);
    });

final unreadNotificationCountProvider = StreamProvider<int>((ref) async* {
  final userId = ref.watch(authProvider.select((auth) => auth.userId));
  if (userId == null) {
    yield 0;
    return;
  }

  final db = ref.watch(databaseProvider);
  await for (final unread in db.watchUnreadNotificationsForUser(userId)) {
    yield unread.length;
  }
});

final reminderSettingForUserProvider =
    StreamProvider.family<ReminderSetting?, String>((ref, userId) {
      final db = ref.watch(databaseProvider);
      return db.watchReminderSetting(userId);
    });

class NotificationActions {
  final Ref ref;

  NotificationActions(this.ref);

  AppDatabase get _db => ref.read(databaseProvider);
  LocalReminderService get _reminders => ref.read(localReminderServiceProvider);

  Future<void> markRead(String notificationId) async {
    await _db.markNotificationRead(notificationId);
  }

  Future<void> markAllRead(String userId) async {
    await _db.markAllNotificationsRead(userId);
  }

  Future<bool> updateDailyReminder({
    required String userId,
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    if (enabled) {
      final granted = await _reminders.requestPermission();
      if (!granted) return false;

      await _reminders.scheduleDailyReminder(
        userId: userId,
        hour: hour,
        minute: minute,
        title: 'Hable reminder',
        body: 'Open Hable and check today\'s habits.',
      );
    } else {
      await _reminders.cancelReminder(userId);
    }

    final now = DateTime.now();
    await _db.saveReminderSetting(
      ReminderSettingsCompanion(
        userId: Value(userId),
        isEnabled: Value(enabled),
        hour: Value(hour),
        minute: Value(minute),
        updatedAt: Value(now),
      ),
    );

    final timeLabel = _formatTime(hour, minute);
    final title = enabled ? 'Daily reminder enabled' : 'Daily reminder turned off';
    final body = enabled
        ? 'Hable will remind you each day at $timeLabel.'
        : 'Daily habit reminders are turned off on this device.';

    await _db.upsertNotificationEvent(
      NotificationEventsCompanion(
        notificationId: Value('reminder_setting:$userId'),
        userId: Value(userId),
        type: const Value(NotificationEventType.reminderSetting),
        sourceType: const Value('reminder_setting'),
        sourceId: Value(userId),
        title: Value(title),
        body: Value(body),
        actionRoute: const Value('profile'),
        actionPayloadJson: Value(
          jsonEncode({'kind': 'reminder_setting', 'enabled': enabled}),
        ),
        createdAt: Value(now),
        readAt: const Value(null),
        updatedAt: Value(now),
      ),
    );

    return true;
  }

  Future<void> updateReminderPreferenceTime({
    required String userId,
    required bool enabled,
    required int hour,
    required int minute,
  }) async {
    await _db.saveReminderSetting(
      ReminderSettingsCompanion(
        userId: Value(userId),
        isEnabled: Value(enabled),
        hour: Value(hour),
        minute: Value(minute),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> restoreReminderForUser(String userId) async {
    final setting = await _db.getReminderSetting(userId);
    if (setting == null || !setting.isEnabled) return;
    try {
      await _reminders.scheduleDailyReminder(
        userId: userId,
        hour: setting.hour,
        minute: setting.minute,
        title: 'Hable reminder',
        body: 'Open Hable and check today\'s habits.',
      );
    } catch (error) {
      debugPrint('Failed to restore reminder schedule: $error');
    }
  }

  Future<void> cancelReminderForUser(String userId) async {
    try {
      await _reminders.cancelReminder(userId);
    } catch (error) {
      debugPrint('Failed to cancel reminder schedule: $error');
    }
  }

  String _formatTime(int hour, int minute) {
    final normalizedHour = hour % 24;
    final normalizedMinute = minute % 60;
    final period = normalizedHour >= 12 ? 'PM' : 'AM';
    final hour12 = normalizedHour % 12 == 0 ? 12 : normalizedHour % 12;
    final minuteText = normalizedMinute.toString().padLeft(2, '0');
    return '$hour12:$minuteText $period';
  }
}

final notificationActionsProvider = Provider<NotificationActions>((ref) {
  return NotificationActions(ref);
});
