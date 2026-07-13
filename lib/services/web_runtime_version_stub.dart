Future<String?> getLoadedServiceWorkerVersion() async => null;

Future<bool> hasReloadAttemptForVersion(String version) async => false;

Future<void> rememberReloadAttemptForVersion(String version) async {}

Future<void> clearReloadAttempt() async {}

Future<void> hardReloadToVersion(String version) async {}
