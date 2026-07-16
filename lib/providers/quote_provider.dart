import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mascot_reminder_copy.dart';
import '../models/daily_quote.dart';
import 'database_provider.dart';
import 'auth_provider.dart';
import '../services/copy_personalization_service.dart';

/// Provides the daily motivational quote.
/// Priority: cached quote from today's sync → personalized local fallback.
final quoteProvider = FutureProvider<DailyQuote>((ref) async {
  final db = ref.watch(databaseProvider);
  final userId = ref.watch(authProvider.select((auth) => auth.userId));

  // The Worker is the only external quote fetcher. Flutter reads its normalized
  // result from Drift and must resolve locally when no quote is available.
  final cached = await db.getTodaysQuote();
  if (cached != null) {
    return DailyQuote(text: cached.quoteText, author: cached.author);
  }

  // No cached Worker quote: use deterministic first-party copy without waiting
  // on a browser-owned third-party request.
  final context = await loadCopyPersonalizationContext(db, userId: userId);
  return MascotReminderCopyHelper.quoteForContext(context);
});
