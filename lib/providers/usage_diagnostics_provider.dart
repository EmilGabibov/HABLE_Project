import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../services/usage_diagnostics_service.dart';
import 'database_provider.dart';

const _usageDiagnosticsLocalEnabled = bool.fromEnvironment(
  'HABLE_USAGE_DIAGNOSTICS_LOCAL_ENABLED',
  defaultValue: true,
);
const _usageDiagnosticsRemoteUploadEnabled = bool.fromEnvironment(
  'HABLE_USAGE_DIAGNOSTICS_REMOTE_UPLOAD_ENABLED',
  defaultValue: false,
);
const _usageDiagnosticsBuildChannelOverride = String.fromEnvironment(
  'HABLE_BUILD_CHANNEL',
);

String _usageDiagnosticsBuildChannel() {
  if (_usageDiagnosticsBuildChannelOverride.isNotEmpty) {
    return _usageDiagnosticsBuildChannelOverride;
  }
  if (kReleaseMode) return 'release';
  if (kProfileMode) return 'profile';
  return 'debug';
}

final usageDiagnosticsProvider = Provider<UsageDiagnosticsService>((ref) {
  final db = ref.watch(databaseProvider);
  final service = UsageDiagnosticsService(
    db: db,
    client: http.Client(),
    apiBaseUrl: apiBaseUrl,
    localCollectionEnabled: _usageDiagnosticsLocalEnabled,
    remoteUploadEnabled: _usageDiagnosticsRemoteUploadEnabled,
    buildChannel: _usageDiagnosticsBuildChannel(),
  );
  service.init();
  ref.onDispose(service.dispose);
  return service;
});
