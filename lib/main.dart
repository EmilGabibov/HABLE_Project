import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/hable_app.dart';
import 'services/background_sync_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: HableApp()));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    unawaited(_initializeBackgroundSync());
  });
}

Future<void> _initializeBackgroundSync() async {
  try {
    await BackgroundSyncService().initialize();
  } catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'Hable startup',
        context: ErrorDescription('initializing background sync'),
      ),
    );
  }
}
