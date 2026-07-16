import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/providers/mud_tuning_provider.dart';
import 'package:hable/services/completion_feedback.dart';

void main() {
  test('maps the same preset to standard and milestone cues', () {
    const settings = MudTuningSettings(
      preset: MudTuningPreset.standard,
      hapticsEnabled: true,
    );

    expect(
      completionHapticCue(settings, milestone: false),
      CompletionHapticCue.medium,
    );
    expect(
      completionHapticCue(settings, milestone: true),
      CompletionHapticCue.heavy,
    );
  });

  test(
    'disabled haptics still resolve a deterministic cue without playing it',
    () {
      const settings = MudTuningSettings(
        preset: MudTuningPreset.intense,
        hapticsEnabled: false,
      );

      expect(
        completionHapticCue(settings, milestone: false),
        CompletionHapticCue.heavy,
      );
    },
  );

  testWidgets('reduced motion removes transient ring delay', (tester) async {
    late Duration duration;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            duration = completionFeedbackDurationFor(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(duration, Duration.zero);
  });
}
