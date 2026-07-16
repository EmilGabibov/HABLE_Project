import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/app/startup_splash.dart';
import 'package:hable/l10n/app_localizations.dart';

Widget _testApp({
  required Widget home,
  Locale locale = const Locale('en'),
  bool disableAnimations = false,
  double textScale = 1,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: MediaQueryData(
        disableAnimations: disableAnimations,
        textScaler: TextScaler.linear(textScale),
      ),
      child: home,
    ),
  );
}

void main() {
  testWidgets('holds a ready app for the configured minimum before fading', (
    tester,
  ) async {
    var dismissals = 0;
    await tester.pumpWidget(
      _testApp(
        home: StartupSplashBoundary(
          ready: true,
          minimumDisplayDuration: const Duration(milliseconds: 800),
          transitionDuration: const Duration(milliseconds: 240),
          onDismissed: () => dismissals += 1,
          child: const ColoredBox(key: Key('ready-app'), color: Colors.blue),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 799));
    expect(find.byKey(const Key('startup-splash')), findsOneWidget);
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const Key('startup-splash-transition')),
          )
          .opacity,
      1,
    );

    await tester.pump(const Duration(milliseconds: 1));
    expect(
      tester
          .widget<AnimatedOpacity>(
            find.byKey(const Key('startup-splash-transition')),
          )
          .opacity,
      0,
    );
    expect(find.byKey(const Key('ready-app')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 241));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('startup-splash')), findsNothing);
    expect(dismissals, 1);
  });

  testWidgets('waits for slow readiness and hands off only once', (
    tester,
  ) async {
    const boundaryKey = ValueKey('boundary');
    var dismissals = 0;

    Widget build({required bool ready}) {
      return _testApp(
        home: StartupSplashBoundary(
          key: boundaryKey,
          ready: ready,
          minimumDisplayDuration: const Duration(milliseconds: 100),
          transitionDuration: const Duration(milliseconds: 50),
          onDismissed: () => dismissals += 1,
          child: const SizedBox.expand(key: Key('ready-app')),
        ),
      );
    }

    await tester.pumpWidget(build(ready: false));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byKey(const Key('startup-splash')), findsOneWidget);

    await tester.pumpWidget(build(ready: true));
    await tester.pump(const Duration(milliseconds: 51));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('startup-splash')), findsNothing);
    expect(dismissals, 1);

    await tester.pumpWidget(build(ready: true));
    await tester.pump(const Duration(seconds: 1));
    expect(dismissals, 1);
  });

  testWidgets('removes transition motion when animations are disabled', (
    tester,
  ) async {
    var dismissals = 0;
    await tester.pumpWidget(
      _testApp(
        disableAnimations: true,
        home: StartupSplashBoundary(
          ready: true,
          minimumDisplayDuration: Duration.zero,
          onDismissed: () => dismissals += 1,
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    await tester.pump();
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('startup-splash')), findsNothing);
    expect(dismissals, 1);
  });

  testWidgets('uses localized semantics and remains usable in RTL large text', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _testApp(
        locale: const Locale('fa'),
        textScale: 2,
        home: const StartupSplashBoundary(
          ready: false,
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(find.bySemanticsLabel('در حال باز کردن Hable'), findsOneWidget);
    expect(find.text('در حال باز کردن Hable'), findsOneWidget);
    expect(
      Directionality.of(tester.element(find.text('در حال باز کردن Hable'))),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}
