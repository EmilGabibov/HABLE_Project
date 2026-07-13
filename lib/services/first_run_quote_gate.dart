import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String firstRunQuoteStorageKey(String userId) => 'first_run_quote_seen_$userId';

Future<bool> shouldShowFirstRunQuoteSplash({
  required FlutterSecureStorage storage,
  required String userId,
}) async {
  final seen = await storage.read(key: firstRunQuoteStorageKey(userId));
  return seen != 'true';
}

Future<void> markFirstRunQuoteSplashSeen({
  required FlutterSecureStorage storage,
  required String userId,
}) {
  return storage.write(key: firstRunQuoteStorageKey(userId), value: 'true');
}
