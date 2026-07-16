import '../database/database.dart';
import '../database/tables.dart';

int? historyPointsForLog(Log log) {
  if (log.status != LogStatus.completed) return null;
  return log.pointsAwarded > 0 ? log.pointsAwarded : 5;
}
