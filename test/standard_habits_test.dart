import 'package:flutter_test/flutter_test.dart';
import 'package:hable/data/standard_habits.dart';

void main() {
  test('custom habit emoji prefixes round-trip, including ZWJ emoji', () {
    expect(leadingHabitEmoji('🎨 Sketching'), '🎨');
    expect(stripLeadingHabitEmoji('🎨 Sketching'), 'Sketching');
    expect(leadingHabitEmoji('👩‍💻 Sketching'), '👩‍💻');
    expect(stripLeadingHabitEmoji('👩‍💻 Sketching'), 'Sketching');
  });

  test(
    'standard titles still resolve when their stored title has an emoji',
    () {
      expect(standardHabitForTitle('Hydration')?.title, 'Hydration');
      expect(standardHabitForTitle('💧 Hydration')?.title, 'Hydration');
      expect(standardHabitForTitle('Reading')?.emoji, '📖');
    },
  );

  test(
    'habit title display adds standard emojis without duplicating custom ones',
    () {
      expect(habitTitleWithEmoji('Hydration'), '💧 Hydration');
      expect(habitTitleWithEmoji('💧 Hydration'), '💧 Hydration');
      expect(habitTitleWithEmoji('👩‍💻 Sketching'), '👩‍💻 Sketching');
      expect(habitTitleWithEmoji('Evening Walk'), 'Evening Walk');
    },
  );
}
