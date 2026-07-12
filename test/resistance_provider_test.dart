import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/providers/resistance_provider.dart';

void main() {
  test('resistanceProvider computes initial state for invalid totalDuration', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: 1, totalDuration: 0)));
    expect(state.resistanceCoefficient, 1.0);
    expect(state.calculatedDurationMs, 1500);
  });

  test('resistanceProvider computes correct duration for early day', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: 1, totalDuration: 10)));
    // R = 1.0 - (1/10) = 0.9
    // Duration = 400 + (1500 - 400) * 0.9 = 400 + 1100 * 0.9 = 400 + 990 = 1390
    expect(state.resistanceCoefficient, 0.9);
    expect(state.calculatedDurationMs, 1390);
  });

  test('resistanceProvider computes correct duration for mid journey', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: 5, totalDuration: 10)));
    // R = 1.0 - 0.5 = 0.5
    // Duration = 400 + 1100 * 0.5 = 400 + 550 = 950
    expect(state.resistanceCoefficient, 0.5);
    expect(state.calculatedDurationMs, 950);
  });

  test('resistanceProvider computes correct duration for final day', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: 10, totalDuration: 10)));
    // R = 1.0 - 1.0 = 0.0
    // Duration = 400 + 0 = 400
    expect(state.resistanceCoefficient, 0.0);
    expect(state.calculatedDurationMs, 400);
  });

  test('resistanceProvider clamps currentDay exceeding totalDuration', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: 15, totalDuration: 10)));
    // R clamped to 0.0
    expect(state.resistanceCoefficient, 0.0);
    expect(state.calculatedDurationMs, 400);
  });

  test('resistanceProvider clamps negative currentDay', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(resistanceProvider((currentDay: -5, totalDuration: 10)));
    // R clamped to 1.0
    expect(state.resistanceCoefficient, 1.0);
    expect(state.calculatedDurationMs, 1500);
  });
}
