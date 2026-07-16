import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hable/l10n/app_localizations.dart';

class StartupSplashBoundary extends StatefulWidget {
  const StartupSplashBoundary({
    required this.ready,
    required this.child,
    this.minimumDisplayDuration = const Duration(milliseconds: 800),
    this.transitionDuration = const Duration(milliseconds: 240),
    this.onDismissed,
    super.key,
  });

  final bool ready;
  final Widget child;
  final Duration minimumDisplayDuration;
  final Duration transitionDuration;
  final VoidCallback? onDismissed;

  @override
  State<StartupSplashBoundary> createState() => _StartupSplashBoundaryState();
}

class _StartupSplashBoundaryState extends State<StartupSplashBoundary> {
  Timer? _minimumTimer;
  bool _minimumElapsed = false;
  bool _splashVisible = true;
  bool _splashRemoved = false;
  bool _removalScheduled = false;
  bool _dismissalReported = false;

  @override
  void initState() {
    super.initState();
    if (widget.minimumDisplayDuration == Duration.zero) {
      _minimumElapsed = true;
    } else {
      _minimumTimer = Timer(widget.minimumDisplayDuration, () {
        if (!mounted) return;
        _minimumElapsed = true;
        _dismissIfReady();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _dismissIfReady());
  }

  @override
  void didUpdateWidget(covariant StartupSplashBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ready && !oldWidget.ready) {
      _dismissIfReady();
    }
  }

  void _dismissIfReady() {
    if (!mounted || !widget.ready || !_minimumElapsed || !_splashVisible) {
      return;
    }
    setState(() => _splashVisible = false);
  }

  void _removeSplash() {
    if (_splashVisible || _splashRemoved || _removalScheduled || !mounted) {
      return;
    }
    _removalScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _splashVisible || _splashRemoved) return;
      setState(() => _splashRemoved = true);
      if (!_dismissalReported) {
        _dismissalReported = true;
        widget.onDismissed?.call();
      }
    });
  }

  @override
  void dispose() {
    _minimumTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final transitionDuration = disableAnimations
        ? Duration.zero
        : widget.transitionDuration;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (!_splashRemoved)
          IgnorePointer(
            ignoring: !_splashVisible,
            child: AnimatedOpacity(
              key: const Key('startup-splash-transition'),
              opacity: _splashVisible ? 1 : 0,
              duration: transitionDuration,
              curve: Curves.easeOut,
              onEnd: _removeSplash,
              child: const _StartupSplashSurface(),
            ),
          ),
      ],
    );
  }
}

class _StartupSplashSurface extends StatelessWidget {
  const _StartupSplashSurface();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final openingLabel = loc?.appStartupOpening ?? 'Opening Hable';
    final colorScheme = Theme.of(context).colorScheme;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);

    return Semantics(
      key: const Key('startup-splash'),
      container: true,
      liveRegion: true,
      label: openingLabel,
      child: ExcludeSemantics(
        child: ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 48,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Hable',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(color: colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      openingLabel,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: disableAnimations
                          ? Icon(
                              Icons.more_horiz_rounded,
                              color: colorScheme.primary,
                            )
                          : CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: colorScheme.primary,
                              semanticsLabel: openingLabel,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
