import 'package:flutter/foundation.dart';

const _apiBaseOverride = String.fromEnvironment('HABLE_API_BASE_URL');
const _appEnvironmentOverride = String.fromEnvironment('HABLE_APP_ENV');
const _stagingApiBaseOverride = String.fromEnvironment(
  'HABLE_STAGING_API_BASE_URL',
);

const String localApiBaseUrl = 'http://127.0.0.1:8787';
const String productionApiBaseUrl = 'https://hable.pages.dev';

enum HableAppEnvironment {
  local,
  staging,
  production,
}

HableAppEnvironment get appEnvironment => resolveAppEnvironment(
  rawEnvironment: _appEnvironmentOverride,
  defaultEnvironment: kReleaseMode
      ? HableAppEnvironment.production
      : HableAppEnvironment.local,
);

String get apiBaseUrl => resolveApiBaseUrl(
  apiBaseOverride: _apiBaseOverride,
  environment: appEnvironment,
  stagingApiBaseUrl: _stagingApiBaseOverride,
);

HableAppEnvironment resolveAppEnvironment({
  required String rawEnvironment,
  required HableAppEnvironment defaultEnvironment,
}) {
  final normalized = rawEnvironment.trim().toLowerCase();
  switch (normalized) {
    case '':
      return defaultEnvironment;
    case 'local':
    case 'dev':
    case 'development':
      return HableAppEnvironment.local;
    case 'staging':
    case 'stage':
      return HableAppEnvironment.staging;
    case 'production':
    case 'prod':
      return HableAppEnvironment.production;
    default:
      return defaultEnvironment;
  }
}

String resolveApiBaseUrl({
  required String apiBaseOverride,
  required HableAppEnvironment environment,
  String stagingApiBaseUrl = '',
}) {
  final normalizedOverride = apiBaseOverride.trim();
  if (normalizedOverride.isNotEmpty) {
    return normalizedOverride;
  }

  switch (environment) {
    case HableAppEnvironment.local:
      return localApiBaseUrl;
    case HableAppEnvironment.staging:
      final normalizedStagingUrl = stagingApiBaseUrl.trim();
      if (normalizedStagingUrl.isNotEmpty) {
        return normalizedStagingUrl;
      }
      return productionApiBaseUrl;
    case HableAppEnvironment.production:
      return productionApiBaseUrl;
  }
}
