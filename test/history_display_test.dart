import 'package:flutter_test/flutter_test.dart';
import 'package:hable/database/database.dart';
import 'package:hable/database/tables.dart';
import 'package:hable/models/history_display.dart';

Log _log(LogStatus status, int points) {
  final now = DateTime(2026, 7, 16);
  return Log(
    logId: 'log-$points',
    habitId: 'habit-1',
    actionDate: now,
    status: status,
    pointsAwarded: points,
    journalNote: null,
    updatedAt: now,
    isSynced: false,
  );
}

void main() {
  test('uses stored completion points when present', () {
    expect(historyPointsForLog(_log(LogStatus.completed, 10)), 10);
  });

  test('uses the legacy completion fallback without awarding skips', () {
    expect(historyPointsForLog(_log(LogStatus.completed, 0)), 5);
    expect(historyPointsForLog(_log(LogStatus.skipped, 0)), isNull);
  });
}
