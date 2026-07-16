import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import 'auth_provider.dart';
import 'database_provider.dart';

final celebrationProvider =
    NotifierProvider<CelebrationNotifier, List<AchievementUnlock>>(
      CelebrationNotifier.new,
    );

class CelebrationNotifier extends Notifier<List<AchievementUnlock>> {
  dynamic _secureStorage;
  String _userId = '';
  Set<String> _revealedIds = {};
  bool _initialized = false;
  StreamSubscription<List<AchievementUnlock>>? _unlocksSubscription;

  @override
  List<AchievementUnlock> build() {
    final db = ref.watch(databaseProvider);
    _userId = ref.watch(authProvider.select((a) => a.userId)) ?? '';
    _secureStorage = ref.watch(secureStorageProvider);
    ref.onDispose(() => _unlocksSubscription?.cancel());

    _init();

    if (_userId.isNotEmpty) {
      _unlocksSubscription?.cancel();
      _unlocksSubscription = db.watchAchievementUnlocks(_userId).listen((
        unlocks,
      ) {
        processUnlocks(unlocks);
      });
    }

    return [];
  }

  Future<void> _init() async {
    if (_userId.isEmpty) return;
    final key = 'revealed_badges_$_userId';
    final stored = await _readStoredFlag(key);
    if (stored != null) {
      try {
        final List<dynamic> decoded = jsonDecode(stored);
        _revealedIds = Set<String>.from(decoded.map((e) => e.toString()));
      } catch (_) {
        _revealedIds = {};
      }
    }
    _initialized = true;
  }

  void processUnlocks(List<AchievementUnlock> unlocks) async {
    if (!_initialized) {
      await _init();
    }

    // Only consider achievements unlocked in the last 48 hours to avoid bombarding users
    // with ancient achievements if they re-install the app.
    final recentCutoff = DateTime.now().subtract(const Duration(hours: 48));
    final queuedIds = state.map((unlock) => unlock.achievementId).toSet();

    final unrevealed = unlocks.where((u) {
      return u.unlockedAt.isAfter(recentCutoff) &&
          !_revealedIds.contains(u.achievementId) &&
          !queuedIds.contains(u.achievementId);
    }).toList();

    if (unrevealed.isNotEmpty) {
      state = [...state, ...unrevealed];
    }
  }

  Future<void> markRevealed(String achievementId) async {
    if (_userId.isEmpty) return;
    _revealedIds.add(achievementId);
    state = state.where((u) => u.achievementId != achievementId).toList();

    final key = 'revealed_badges_$_userId';
    await _writeStoredFlag(key, jsonEncode(_revealedIds.toList()));
  }

  Future<String?> _readStoredFlag(String key) async {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      final preferences = await SharedPreferences.getInstance();
      return preferences.getString(key);
    }
    return _secureStorage.read(key: key);
  }

  Future<void> _writeStoredFlag(String key, String value) async {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString(key, value);
      return;
    }
    await _secureStorage.write(key: key, value: value);
  }
}
