import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/contrast_utils.dart';

void main() {
  group('ACLightWeekThemeData контрастность WCAG 2.1 AA', () {
    late ACLightWeekThemeData theme;

    setUp(() {
      theme = ACLightWeekThemeData();
    });

    test('textColor имеет контраст >= 4.5:1 на белом фоне', () {
      const white = Color(0xFFFFFFFF);
      final ratio = contrastRatio(theme.textColor, white);

      expect(
        ratio,
        greaterThanOrEqualTo(4.5),
        reason: 'textColor ${theme.textColor} имеет контраст '
            '${ratio.toStringAsFixed(2)}:1, требуется >= 4.5:1',
      );
    });
  });
}
