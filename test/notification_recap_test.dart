import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/services/connectivity_service.dart';
import 'package:hable/services/local_reminder_service.dart';
import 'package:hable/services/sync_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/native.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<LocalReminderService>(),
  MockSpec<ConnectivityService>(),
  MockSpec<FlutterSecureStorage>(),
])
import 'notification_recap_test.mocks.dart';

void main() {
  late AppDatabase db;
  late MockLocalReminderService mockReminderService;
  late MockConnectivityService mockConnectivity;
  late MockFlutterSecureStorage mockStorage;
  late SyncService syncService;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    mockReminderService = MockLocalReminderService();
    mockConnectivity = MockConnectivityService();
    mockStorage = MockFlutterSecureStorage();

    when(mockReminderService.supportsScheduling).thenReturn(true);

    syncService = SyncService(
      db: db,
      connectivity: mockConnectivity,
      storage: mockStorage,
      localReminderService: mockReminderService,
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('coalesceAndScheduleSocialRecap creates correct title and body for single nudge', () async {
    await db.upsertNotificationEvent(
      NotificationEventsCompanion.insert(
        notificationId: '1',
        userId: 'user1',
        type: 'nudge',
        title: 'Nudge',
        body: 'Alice nudged you',
        createdAt: DateTime.now(),
        actionPayloadJson: '{"route": "social", "subTab": 1}',
      ),
    );

    await syncService.coalesceAndScheduleSocialRecap('user1');

    verify(mockReminderService.scheduleReminder(
      userId: 'user1',
      type: ReminderType.dailyHabit,
      hour: anyNamed('hour'),
      minute: anyNamed('minute'),
      title: 'Social Recap',
      body: 'Alice nudged you',
      payload: '{"route": "social", "subTab": 1}',
    )).called(1);
  });

  test('coalesceAndScheduleSocialRecap coalesces multiple nudges', () async {
    await db.upsertNotificationEvent(
      NotificationEventsCompanion.insert(
        notificationId: '1',
        userId: 'user1',
        type: 'nudge',
        title: 'Nudge',
        body: 'Alice nudged you',
        createdAt: DateTime.now(),
      ),
    );
    await db.upsertNotificationEvent(
      NotificationEventsCompanion.insert(
        notificationId: '2',
        userId: 'user1',
        type: 'nudge',
        title: 'Nudge',
        body: 'Bob nudged you',
        createdAt: DateTime.now(),
      ),
    );

    await syncService.coalesceAndScheduleSocialRecap('user1');

    verify(mockReminderService.scheduleReminder(
      userId: 'user1',
      type: ReminderType.dailyHabit,
      hour: anyNamed('hour'),
      minute: anyNamed('minute'),
      title: 'Social Recap',
      body: 'You have 2 new nudges from friends.',
      payload: '{"route": "social"}',
    )).called(1);
  });
}
