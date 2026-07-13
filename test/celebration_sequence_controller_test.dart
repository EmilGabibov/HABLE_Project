import 'package:flutter_test/flutter_test.dart';
import 'package:hable/services/celebration_sequence_controller.dart';

void main() {
  test('drains queued celebrations in order', () async {
    final controller = CelebrationSequenceController<String>();
    final seen = <String>[];

    controller.enqueue('completion-1');
    controller.enqueue('achievement-1');

    await controller.drain((item) async {
      seen.add(item);
    });

    expect(seen, ['completion-1', 'achievement-1']);
    expect(controller.hasItems, isFalse);
  });

  test('dedupes queued achievements until they are drained', () async {
    final controller = CelebrationSequenceController<String>();
    final seen = <String>[];

    controller.enqueue('achievement-1', dedupeKey: 'badge:first_win');
    controller.enqueue('achievement-1-duplicate', dedupeKey: 'badge:first_win');
    controller.enqueue('completion-1', dedupeKey: 'completion:1');

    await controller.drain((item) async {
      seen.add(item);
    });

    controller.enqueue('achievement-1-repeat', dedupeKey: 'badge:first_win');
    await controller.drain((item) async {
      seen.add(item);
    });

    expect(seen, ['achievement-1', 'completion-1', 'achievement-1-repeat']);
  });
}
