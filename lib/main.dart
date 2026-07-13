import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/database_provider.dart';
import 'providers/habit_providers.dart';
import 'providers/usage_diagnostics_provider.dart';
import 'providers/sync_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/usage_tracked_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'services/background_sync_service.dart';
import 'services/local_reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await BackgroundSyncService().initialize();

  runApp(const ProviderScope(child: HableApp()));
}

class HableApp extends ConsumerWidget {
  const HableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageDiagnosticsProvider);
    return MaterialApp(
      title: 'Hable',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      navigatorObservers: [usageRouteObserver],
      home: const _AppGate(),
    );
  }
}

/// Routes to AuthScreen if no user exists, otherwise to the three-tab app shell.
class _AppGate extends ConsumerStatefulWidget {
  const _AppGate();

  @override
  ConsumerState<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<_AppGate> with WidgetsBindingObserver {
  String? _lastSyncedUserId;
  final GlobalKey<MainNavigationShellState> _shellKey = GlobalKey<MainNavigationShellState>();
  StreamSubscription<String?>? _payloadSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On first load, wait for build to finish then trigger sync if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartSync();
      _setupNotificationTapHandling();
    });
  }

  Future<void> _setupNotificationTapHandling() async {
    final localReminder = ref.read(localReminderServiceProvider);
    
    // Handle initial payload from a cold start
    final initialPayload = await localReminder.getInitialPayload();
    if (initialPayload != null) {
      _handlePayload(initialPayload);
    }

    // Listen to foreground/background taps
    _payloadSub = localReminder.onPayloadTapped.listen((payload) {
      if (payload != null) _handlePayload(payload);
    });
  }

  void _handlePayload(String payloadStr) {
    if (payloadStr == 'home') {
      _shellKey.currentState?.switchToTab(0);
      return;
    }
    
    try {
      final payload = jsonDecode(payloadStr) as Map<String, dynamic>;
      if (payload['route'] == 'social') {
        _shellKey.currentState?.switchToTab(1, socialSubTab: 1);
      }
    } catch (_) {
      // Ignore parsing errors for simple payloads
    }
  }

  @override
  void dispose() {
    _payloadSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkAndStartSync() async {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.userId != null) {
      if (_lastSyncedUserId != authState.userId) {
        ref.read(databaseProvider).removeSelfFromSocialCaches(authState.userId!);
      }
      ref.read(foregroundSyncControllerProvider.notifier).startPolling(authState.userId!);
      ref.read(foregroundSyncControllerProvider.notifier).syncNow(authState.userId!);
      
      if (mounted) {
        setState(() {
          _lastSyncedUserId = authState.userId;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndStartSync();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (!authState.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated || authState.userId == null) {
      return const AuthScreen();
    }

    // Ensure polling is active when authState updates from unauthenticated to authenticated
    ref.listen(authProvider, (previous, next) {
      if ((previous == null || !previous.isAuthenticated) && next.isAuthenticated && next.userId != null) {
         _checkAndStartSync();
      } else if ((previous != null && previous.isAuthenticated) && !next.isAuthenticated) {
          ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
          if (mounted) {
            setState(() {
              _lastSyncedUserId = null;
            });
          }
       }
     });

    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (_) => MainNavigationShell(key: _shellKey, userId: authState.userId!),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
