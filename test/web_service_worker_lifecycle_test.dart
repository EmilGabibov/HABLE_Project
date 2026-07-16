import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'notification navigation handles stale clients without rejected events',
    () {
      final source = File('web/push_service_worker.js').readAsStringSync();

      expect(source, contains('event.waitUntil((async () => {'));
      expect(source, contains('await existing.navigate(target);'));
      expect(source, contains('return await existing.focus();'));
      expect(source, contains('return await self.clients.openWindow(target);'));
      expect(source, contains('})().catch(() => undefined));'));
    },
  );
}
