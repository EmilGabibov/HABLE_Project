import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/usage_diagnostics_provider.dart';

final usageRouteObserver = RouteObserver<ModalRoute<void>>();

class UsageTrackedScreen extends ConsumerStatefulWidget {
  const UsageTrackedScreen({
    super.key,
    required this.screenName,
    required this.child,
  });

  final String screenName;
  final Widget child;

  @override
  ConsumerState<UsageTrackedScreen> createState() => _UsageTrackedScreenState();
}

class _UsageTrackedScreenState extends ConsumerState<UsageTrackedScreen>
    with RouteAware, WidgetsBindingObserver {
  ModalRoute<void>? _route;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is ModalRoute<void> && route != _route) {
      if (_route != null) {
        usageRouteObserver.unsubscribe(this);
      }
      _route = route;
      usageRouteObserver.subscribe(this, route);
      if (route.isCurrent) {
        unawaited(_markVisible());
      }
    } else if (route == null) {
      unawaited(_markVisible());
    }
  }

  @override
  void dispose() {
    usageRouteObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_markHidden());
    super.dispose();
  }

  @override
  void didPush() {
    unawaited(_markVisible());
  }

  @override
  void didPopNext() {
    unawaited(_markVisible());
  }

  @override
  void didPushNext() {
    unawaited(_markHidden());
  }

  @override
  void didPop() {
    unawaited(_markHidden());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_route?.isCurrent ?? true) {
        unawaited(_markVisible());
      }
      return;
    }

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      unawaited(_markHidden());
    }
  }

  Future<void> _markVisible() {
    return ref
        .read(usageDiagnosticsProvider)
        .screenBecameVisible(widget.screenName);
  }

  Future<void> _markHidden() {
    return ref
        .read(usageDiagnosticsProvider)
        .screenBecameHidden(widget.screenName);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
