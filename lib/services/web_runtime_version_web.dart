// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:html' as html;

const _reloadAttemptKey = 'hable_web_reload_attempt_version';

Future<String?> getLoadedServiceWorkerVersion() async {
  final normalized = html
      .window
      .localStorage['hable_loaded_service_worker_version']
      ?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  return normalized;
}

Future<bool> hasReloadAttemptForVersion(String version) async {
  return html.window.localStorage[_reloadAttemptKey] == version;
}

Future<void> rememberReloadAttemptForVersion(String version) async {
  html.window.localStorage[_reloadAttemptKey] = version;
}

Future<void> clearReloadAttempt() async {
  html.window.localStorage.remove(_reloadAttemptKey);
}

Future<void> hardReloadToVersion(String version) async {
  final current = Uri.parse(html.window.location.href);
  final queryParameters = Map<String, String>.from(current.queryParameters);
  queryParameters['v'] = version;
  queryParameters['ts'] = DateTime.now().millisecondsSinceEpoch.toString();
  final next = current.replace(queryParameters: queryParameters);
  html.window.location.replace(next.toString());
}
