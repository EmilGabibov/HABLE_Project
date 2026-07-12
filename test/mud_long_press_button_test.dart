import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/widgets/mud_long_press_button.dart';

void main() {
  Widget buildTestSubject({
    required VoidCallback onCompletion,
    int durationMs = 1200,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MudLongPressButton(
            resistanceCoefficient: 0.5,
            calculatedDurationMs: durationMs,
            onCompletion: onCompletion,
          ),
        ),
      ),
    );
  }

  testWidgets('early release cancels completion', (tester) async {
    var completions = 0;

    await tester.pumpWidget(
      buildTestSubject(onCompletion: () => completions += 1),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(MudLongPressButton)),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(completions, 0);
  });

  testWidgets('full hold completes exactly once', (tester) async {
    var completions = 0;

    await tester.pumpWidget(
      buildTestSubject(onCompletion: () => completions += 1, durationMs: 600),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(MudLongPressButton)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump();
    expect(completions, 1);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(completions, 1);
  });
}
