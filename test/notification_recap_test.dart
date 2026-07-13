import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/services/connectivity_service.dart';
import 'package:hable/services/local_reminder_service.dart';
import 'package:hable/services/sync_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' show Value;

/// Fake LocalReminderService that captures scheduleReminder calls.
class FakeLocalReminderService extends LocalReminderService {
  final List<Map<String, dynamic>> scheduledCalls = [];

  @override
  bool get supportsScheduling => true;

  @override
  Future<void> scheduleReminder({
    required int notificationId,
    required String userId,
    required ReminderType type,
    required int hour,
    required int minute,
    required String title,
    required String body,
    String? payload,
  }) async {
    scheduledCalls.add({
      'notificationId': notificationId,
      'userId': userId,
      'type': type,
      'hour': hour,
      'minute': minute,
      'title': title,
      'body': body,
      'payload': payload,
    });
  }
}

void main() {
  late AppDatabase db;
  late FakeLocalReminderService fakeReminderService;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    fakeReminderService = FakeLocalReminderService();

    syncService = SyncService(
      db: db,
      connectivity: ConnectivityService(),
      storage: const FlutterSecureStorage(),
      localReminderService: fakeReminderService,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test(
    'coalesceAndScheduleSocialRecap passes single nudge body and payload unchanged',
    () async {
      await db.upsertNotificationEvent(
        NotificationEventsCompanion.insert(
          notificationId: '1',
          userId: 'user1',
          type: NotificationEventType.nudge,
          sourceType: 'nudge',
          title: 'Nudge',
          body: 'Alice nudged you',
          createdAt: Value(DateTime.now()),
          actionPayloadJson: const Value('{"route": "social", "subTab": 1}'),
        ),
      );

      await syncService.coalesceAndScheduleSocialRecap('user1');

      expect(fakeReminderService.scheduledCalls, hasLength(1));
      final call = fakeReminderService.scheduledCalls.first;
      expect(call['title'], 'Social Recap');
      expect(call['body'], 'Alice nudged you');
      expect(call['payload'], '{"route": "social", "subTab": 1}');
      expect(call['type'], ReminderType.dailyHabit);
    },
  );

  test(
    'coalesceAndScheduleSocialRecap coalesces multiple nudges into recap copy',
    () async {
      await db.upsertNotificationEvent(
        NotificationEventsCompanion.insert(
          notificationId: '1',
          userId: 'user1',
          type: NotificationEventType.nudge,
          sourceType: 'nudge',
          title: 'Nudge',
          body: 'Alice nudged you',
          createdAt: Value(DateTime.now()),
        ),
      );
      await db.upsertNotificationEvent(
        NotificationEventsCompanion.insert(
          notificationId: '2',
          userId: 'user1',
          type: NotificationEventType.nudge,
          sourceType: 'nudge',
          title: 'Nudge',
          body: 'Bob nudged you',
          createdAt: Value(DateTime.now()),
        ),
      );

      await syncService.coalesceAndScheduleSocialRecap('user1');

      expect(fakeReminderService.scheduledCalls, hasLength(1));
      final call = fakeReminderService.scheduledCalls.first;
      expect(call['title'], 'Social Recap');
      expect(call['body'], 'You have 2 new nudges from friends.');
      expect(call['payload'], '{"route": "social"}');
    },
  );

  test(
    'coalesceAndScheduleSocialRecap coalesces nudges and invites together',
    () async {
      await db.upsertNotificationEvent(
        NotificationEventsCompanion.insert(
          notificationId: '1',
          userId: 'user1',
          type: NotificationEventType.nudge,
          sourceType: 'nudge',
          title: 'Nudge',
          body: 'Alice nudged you',
          createdAt: Value(DateTime.now()),
        ),
      );
      await db.upsertNotificationEvent(
        NotificationEventsCompanion.insert(
          notificationId: '2',
          userId: 'user1',
          type: NotificationEventType.habitInvitation,
          sourceType: 'habit_invitation',
          title: 'Invite',
          body: 'Bob invited you',
          createdAt: Value(DateTime.now()),
        ),
      );

      await syncService.coalesceAndScheduleSocialRecap('user1');

      expect(fakeReminderService.scheduledCalls, hasLength(1));
      final call = fakeReminderService.scheduledCalls.first;
      expect(call['body'], 'You have 1 nudge and 1 invite.');
    },
  );

  test(
    'coalesceAndScheduleSocialRecap skips scheduling when no social events',
    () async {
      await syncService.coalesceAndScheduleSocialRecap('user1');

      expect(fakeReminderService.scheduledCalls, isEmpty);
    },
  );

  test(
    'coalesceAndScheduleSocialRecap uses partner check-ins when no unread events exist',
    () async {
      await db.upsertPartnerSnapshot(
        PartnerSnapshotsCompanion.insert(
          habitId: 'habit-1',
          partnerUserId: 'user-2',
          username: 'Alice',
          currentDuration: const Value(3),
          hasCompletedToday: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await db.upsertPartnerSnapshot(
        PartnerSnapshotsCompanion.insert(
          habitId: 'habit-2',
          partnerUserId: 'user-3',
          username: 'Bob',
          currentDuration: const Value(1),
          hasCompletedToday: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await syncService.coalesceAndScheduleSocialRecap('user1');

      expect(fakeReminderService.scheduledCalls, hasLength(1));
      expect(
        fakeReminderService.scheduledCalls.single['body'],
        '2 friends checked in on shared habits today.',
      );
    },
  );

  test('buildSocialRecapPlan marks stale recap sources', () async {
    final staleTime = DateTime.now().subtract(const Duration(hours: 8));
    await db.upsertPartnerSnapshot(
      PartnerSnapshotsCompanion.insert(
        habitId: 'habit-1',
        partnerUserId: 'user-2',
        username: 'Alice',
        currentDuration: const Value(3),
        hasCompletedToday: const Value(true),
        updatedAt: Value(staleTime),
      ),
    );

    final plan = await syncService.buildSocialRecapPlan('user1');
    expect(plan, isNotNull);
    expect(plan!.isStaleAt(DateTime.now()), isTrue);
  });
}
