import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/contrast_utils.dart';

void main() {
  group('ACLightDayThemeData контрастность WCAG 2.1 AA', () {
    late ACLightDayThemeData theme;

    setUp(() {
      theme = ACLightDayThemeData();
    });

    test('inactiveTextColor имеет контраст >= 3:1 на белом фоне', () {
      const white = Color(0xFFFFFFFF);
      final ratio = contrastRatio(theme.inactiveTextColor, white);

      expect(
        ratio,
        greaterThanOrEqualTo(3.0),
        reason: 'inactiveTextColor ${theme.inactiveTextColor} имеет контраст '
            '${ratio.toStringAsFixed(2)}:1, требуется >= 3:1',
      );
    });
  });
}
