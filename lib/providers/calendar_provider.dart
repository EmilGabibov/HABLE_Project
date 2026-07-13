import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_timezone/flutter_timezone.dart';
import '../config/api_config.dart' show apiBaseUrl;
import 'auth_provider.dart';
import 'database_provider.dart';
import '../database/tables.dart';

class CalendarFeedState {
  final bool isLoading;
  final String? feedUrl;
  final String? error;

  CalendarFeedState({this.isLoading = false, this.feedUrl, this.error});

  CalendarFeedState copyWith({
    bool? isLoading,
    String? feedUrl,
    String? error,
    bool clearError = false,
  }) {
    return CalendarFeedState(
      isLoading: isLoading ?? this.isLoading,
      feedUrl: feedUrl ?? this.feedUrl,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CalendarFeedNotifier extends Notifier<CalendarFeedState> {
  @override
  CalendarFeedState build() {
    return CalendarFeedState();
  }

  Future<String> _appendLocalSettingsToUrl(String url) async {
    try {
      final tz = await FlutterTimezone.getLocalTimezone();
      final db = ref.read(databaseProvider);
      final userId = ref.read(authProvider).userId;

      String modifiedUrl = '$url?tz=${Uri.encodeComponent(tz.toString())}';

      if (userId != null) {
        final reminderSettings = await db.getReminderSettings(userId, ReminderType.dailyHabit);
        final reminderSetting = reminderSettings.where((r) => r.isEnabled).firstOrNull;
        if (reminderSetting != null) {
          modifiedUrl = '$modifiedUrl&alarmHour=${reminderSetting.hour}&alarmMinute=${reminderSetting.minute}';
        }
      }
      return modifiedUrl;
    } catch (e) {
      print('Error appending timezone/alarm to calendar feed URL: $e');
      return url;
    }
  }

  Future<void> fetchCalendarFeedUrl() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        state = state.copyWith(isLoading: false, error: 'Not authenticated');
        return;
      }

      final token = authState.token!;
      final baseUrl = apiBaseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/calendar-feed'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? feedUrl = data['feed_url'] as String?;

        if (feedUrl != null) {
          feedUrl = await _appendLocalSettingsToUrl(feedUrl);
        }

        state = state.copyWith(
          isLoading: false,
          feedUrl: feedUrl,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to fetch calendar feed URL',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> rotateCalendarToken() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated) {
        state = state.copyWith(isLoading: false, error: 'Not authenticated');
        return;
      }

      final token = authState.token!;
      final baseUrl = apiBaseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/api/user/calendar-feed/rotate'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? feedUrl = data['feed_url'] as String?;

        if (feedUrl != null) {
          feedUrl = await _appendLocalSettingsToUrl(feedUrl);
        }

        state = state.copyWith(
          isLoading: false,
          feedUrl: feedUrl,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to rotate calendar token',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final calendarFeedProvider =
    NotifierProvider<CalendarFeedNotifier, CalendarFeedState>(
      () => CalendarFeedNotifier(),
    );
