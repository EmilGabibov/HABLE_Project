import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String firstRunQuoteStorageKey(String userId) => 'first_run_quote_seen_$userId';

Future<bool> shouldShowFirstRunQuoteSplash({
  required FlutterSecureStorage storage,
  required String userId,
}) async {
  final key = firstRunQuoteStorageKey(userId);
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(key) != true;
  }
  final seen = await storage.read(key: key);
  return seen != 'true';
}

Future<void> markFirstRunQuoteSplashSeen({
  required FlutterSecureStorage storage,
  required String userId,
}) async {
  final key = firstRunQuoteStorageKey(userId);
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, true);
    return;
  }
  await storage.write(key: key, value: 'true');
}
