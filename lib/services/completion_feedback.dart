import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../providers/mud_tuning_provider.dart';

const completionFeedbackDuration = Duration(milliseconds: 1200);

enum CompletionHapticCue { selection, medium, light, heavy, vibrate }

CompletionHapticCue completionHapticCue(
  MudTuningSettings settings, {
  required bool milestone,
}) {
  if (milestone) {
    return switch (settings.hapticProfile) {
      MudHapticProfile.soft => CompletionHapticCue.light,
      MudHapticProfile.standard => CompletionHapticCue.heavy,
      MudHapticProfile.strong => CompletionHapticCue.vibrate,
    };
  }
  return switch (settings.hapticProfile) {
    MudHapticProfile.soft => CompletionHapticCue.selection,
    MudHapticProfile.standard => CompletionHapticCue.medium,
    MudHapticProfile.strong => CompletionHapticCue.heavy,
  };
}

void playCompletionHaptic(
  MudTuningSettings settings, {
  required bool milestone,
}) {
  if (!settings.hapticsEnabled) return;

  switch (completionHapticCue(settings, milestone: milestone)) {
    case CompletionHapticCue.selection:
      HapticFeedback.selectionClick();
    case CompletionHapticCue.medium:
      HapticFeedback.mediumImpact();
    case CompletionHapticCue.light:
      HapticFeedback.lightImpact();
    case CompletionHapticCue.heavy:
      HapticFeedback.heavyImpact();
    case CompletionHapticCue.vibrate:
      HapticFeedback.vibrate();
  }
}

Duration completionFeedbackDurationFor(BuildContext context) {
  return MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : completionFeedbackDuration;
}
