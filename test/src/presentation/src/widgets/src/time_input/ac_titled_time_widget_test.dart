import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ACTitledTimeWidget boldText (T036)', () {
    testWidgets(
      'при boldText=true fontWeight заголовка увеличен',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(boldText: true),
            child: MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 400,
                  height: 100,
                  child: ACTitledTimeWidget.single(title: 'Время'),
                ),
              ),
            ),
          ),
        );

        // Assert -- заголовок "Время" имеет увеличенный fontWeight
        final textWidget = tester.widget<Text>(find.text('Время'));
        expect(
          textWidget.style?.fontWeight,
          isNotNull,
          reason: 'fontWeight заголовка должен быть задан при boldText=true',
        );
        expect(
          textWidget.style!.fontWeight!.value,
          greaterThanOrEqualTo(FontWeight.w700.value),
          reason: 'fontWeight заголовка должен быть >= w700 при boldText=true',
        );
      },
    );
  });
}
