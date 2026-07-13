import 'package:flutter_test/flutter_test.dart';
import 'package:hable/services/web_version_gate_service.dart';

void main() {
  test('compareBuildIdentifiers compares numeric build ids numerically', () {
    expect(compareBuildIdentifiers('10', '2'), greaterThan(0));
    expect(compareBuildIdentifiers('2', '10'), lessThan(0));
    expect(compareBuildIdentifiers('10', '10'), 0);
  });

  test('compareBuildIdentifiers falls back to string comparison', () {
    expect(compareBuildIdentifiers('abc', 'abd'), lessThan(0));
    expect(compareBuildIdentifiers('abd', 'abc'), greaterThan(0));
  });
}
