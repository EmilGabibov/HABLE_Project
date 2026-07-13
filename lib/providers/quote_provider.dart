import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../data/fallback_quotes.dart';
import 'database_provider.dart';

// Fallback quotes for users who recently skipped a habit
const recentSkipQuotes = [
  "A stumble is not a fall. Get back up.",
  "Missing a day doesn't erase your progress. Keep going.",
  "Rest is okay. Quitting is not. Start again today.",
  "Progress isn't a straight line. You've got this.",
];

/// Provides the daily motivational quote.
/// Priority: cached quote from today → personalized fallback → random fallback.
final quoteProvider = FutureProvider<String>((ref) async {
  final db = ref.watch(databaseProvider);

  // Try to get a cached quote from today's sync
  final cached = await db.getTodaysQuote();
  if (cached != null) return cached.quoteText;

  // Check if the user has skipped a habit in the last 2 days
  final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
  final recentLogs = await (db.select(db.logs)
        ..where((l) => l.actionDate.isBiggerOrEqualValue(twoDaysAgo)))
      .get();
      
  final hasRecentSkip = recentLogs.any((log) => log.status.name == 'skipped');
  final random = Random();

  if (hasRecentSkip) {
    return recentSkipQuotes[random.nextInt(recentSkipQuotes.length)];
  }

  // Offline fallback — never show blank or error text
  return fallbackQuotes[random.nextInt(fallbackQuotes.length)];
});
