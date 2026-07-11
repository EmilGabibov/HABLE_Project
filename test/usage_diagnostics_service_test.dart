import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/services/usage_diagnostics_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('UsageDiagnosticsService', () {
    test(
      'records coarse aggregate counters and rounds visible duration',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        var now = DateTime.utc(2026, 7, 11, 12, 0, 0);
        final service = UsageDiagnosticsService(
          db: db,
          client: MockClient((_) async => http.Response('{}', 200)),
          apiBaseUrl: 'http://127.0.0.1:8787',
          localCollectionEnabled: true,
          remoteUploadEnabled: false,
          buildChannel: 'debug',
          now: () => now,
        );

        await service.recordAppOpen();
        await service.screenBecameVisible('home');
        now = now.add(const Duration(seconds: 3));
        await service.screenBecameHidden('home');

        final rows = await db.getUsageAggregateBuckets();
        expect(rows, hasLength(3));

        final appOpen = rows.firstWhere(
          (row) => row.screenName == 'app' && row.metricName == 'app_open',
        );
        final visit = rows.firstWhere(
          (row) => row.screenName == 'home' && row.metricName == 'screen_visit',
        );
        final visible = rows.firstWhere(
          (row) =>
              row.screenName == 'home' && row.metricName == 'screen_visible_ms',
        );

        expect(appOpen.count, 1);
        expect(appOpen.totalDurationMs, 0);
        expect(visit.count, 1);
        expect(visit.totalDurationMs, 0);
        expect(visible.count, 0);
        expect(visible.totalDurationMs, 5000);

        service.dispose();
        await db.close();
      },
    );

    test(
      'upload payload omits identifiers and remote upload stays explicit',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        var requestCount = 0;
        final service = UsageDiagnosticsService(
          db: db,
          client: MockClient((request) async {
            requestCount += 1;
            return http.Response('{"ok":true}', 200);
          }),
          apiBaseUrl: 'http://127.0.0.1:8787',
          localCollectionEnabled: true,
          remoteUploadEnabled: false,
          buildChannel: 'debug',
          now: () => DateTime.utc(2026, 7, 11, 12, 0, 0),
        );

        await service.recordAppOpen();
        await service.screenBecameVisible('auth');
        await service.screenBecameHidden('auth');
        await service.uploadPendingBuckets();

        expect(requestCount, 0);

        final payload = service.buildUploadPayload(
          await db.getPendingUsageAggregateBuckets(),
        );
        final buckets = payload['buckets'] as List<Object?>;
        expect(buckets, isNotEmpty);

        final firstBucket = buckets.first as Map<String, Object?>;
        expect(
          firstBucket.keys,
          containsAll([
            'bucket_date',
            'platform',
            'build_channel',
            'screen_name',
            'metric_name',
            'count',
            'total_duration_ms',
          ]),
        );
        expect(firstBucket.containsKey('user_id'), isFalse);
        expect(firstBucket.containsKey('username'), isFalse);
        expect(firstBucket.containsKey('email'), isFalse);
        expect(firstBucket.containsKey('token'), isFalse);

        service.dispose();
        await db.close();
      },
    );
  });
}
