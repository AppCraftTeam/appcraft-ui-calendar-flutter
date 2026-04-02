import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/contrast_utils.dart';

void main() {
  group('ACLightTimeInputThemeData контрастность WCAG 2.1 AA', () {
    late ACLightTimeInputThemeData theme;

    setUp(() {
      theme = ACLightTimeInputThemeData();
    });

    test('hintColor имеет контраст >= 3:1 на backgroundColor', () {
      // backgroundColor полупрозрачный — композитируем на белом
      final effectiveBackground = compositeOnBackground(
        theme.backgroundColor,
        const Color(0xFFFFFFFF),
      );
      final ratio = contrastRatio(theme.hintColor, effectiveBackground);

      expect(
        ratio,
        greaterThanOrEqualTo(3.0),
        reason: 'hintColor ${theme.hintColor} на фоне '
            '$effectiveBackground имеет контраст '
            '${ratio.toStringAsFixed(2)}:1, требуется >= 3:1',
      );
    });
  });
}
