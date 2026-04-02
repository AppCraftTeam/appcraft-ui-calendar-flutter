import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/contrast_utils.dart';

void main() {
  group('ACLightWheelPickerThemeData контрастность WCAG 2.1 AA', () {
    late ACLightWheelPickerThemeData theme;

    setUp(() {
      theme = ACLightWheelPickerThemeData();
    });

    test('itemTextColor имеет контраст >= 3:1 на белом фоне', () {
      const white = Color(0xFFFFFFFF);
      // itemTextColor полупрозрачный — композитируем на белом
      final effectiveColor = compositeOnBackground(
        theme.itemTextColor,
        white,
      );
      final ratio = contrastRatio(effectiveColor, white);

      expect(
        ratio,
        greaterThanOrEqualTo(3.0),
        reason: 'itemTextColor (composited) $effectiveColor имеет контраст '
            '${ratio.toStringAsFixed(2)}:1, требуется >= 3:1',
      );
    });
  });
}
