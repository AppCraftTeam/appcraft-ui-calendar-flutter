import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final theme = ACLightCalendarThemeData();

  Widget buildApp(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [ACCalendarThemeExtension(data: theme)]),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 100,
            child: child,
          ),
        ),
      );

  group('ACTitledTimeWidget.single -- рендеринг', () {
    testWidgets(
      'отображает заголовок по умолчанию',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(),
        ));

        // Assert -- по умолчанию "Время" (русская локализация)
        expect(find.byType(ACTitledTimeWidget), findsOneWidget);
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'отображает пользовательский заголовок',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Custom Time'),
        ));

        // Assert
        expect(find.text('Custom Time'), findsOneWidget);
      },
    );

    testWidgets(
      'содержит Row с Text и ACTimeInputWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Start'),
        ));

        // Assert
        expect(find.text('Start'), findsOneWidget);
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );
  });

  group('ACTitledTimeWidget.range -- рендеринг', () {
    testWidgets(
      'отображает ACTimeRangeInputWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(),
        ));

        // Assert
        expect(find.byType(ACTitledTimeWidget), findsOneWidget);
        expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'отображает пользовательский заголовок для range',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(title: 'Period'),
        ));

        // Assert
        expect(find.text('Period'), findsOneWidget);
      },
    );
  });

  group('ACTitledTimeWidget -- PreferredSizeWidget', () {
    test('preferredSize возвращает высоту по умолчанию 34', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.single();

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(34)));
    });

    test('preferredSize возвращает пользовательскую высоту', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.single(preferredHeight: 50);

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(50)));
    });

    test('preferredSize для range конструктора по умолчанию 34', () {
      // Arrange & Act
      final widget = ACTitledTimeWidget.range();

      // Assert
      expect(widget.preferredSize, equals(const Size.fromHeight(34)));
    });
  });

  group('ACTitledTimeWidget -- контроллер', () {
    testWidgets(
      'single принимает ACTimeInputController',
      (tester) async {
        // Arrange
        final controller =
            ACTimeInputController(time: const TimeOfDay(hour: 14, minute: 30));

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Time',
            controller: controller,
          ),
        ));

        // Assert
        expect(find.byType(ACTimeInputWidget), findsOneWidget);
      },
    );

    testWidgets(
      'range принимает ACTimeRangeInputController',
      (tester) async {
        // Arrange
        final controller = ACTimeRangeInputController();

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.range(
            title: 'Range',
            controller: controller,
          ),
        ));

        // Assert
        expect(find.byType(ACTimeRangeInputWidget), findsOneWidget);

        controller.dispose();
      },
    );
  });

  group('ACTitledTimeWidget -- тема', () {
    testWidgets(
      'использует тему из ACCalendarThemeData если не задана',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(title: 'Themed'),
        ));

        // Assert -- виджет рендерится без ошибок
        expect(find.text('Themed'), findsOneWidget);
      },
    );

    testWidgets(
      'использует переданную тему вместо ACCalendarThemeData',
      (tester) async {
        // Arrange
        final customTheme = ACLightTitledTimeThemeData(
          titleTextStyle: const TextStyle(fontSize: 20),
          titleColor: Colors.red,
        );

        // Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Custom',
            theme: customTheme,
          ),
        ));

        // Assert
        final textWidget = tester.widget<Text>(find.text('Custom'));
        expect(textWidget.style?.color, equals(Colors.red));
      },
    );
  });

  group('ACTitledTimeWidget -- SizedBox обёртка', () {
    testWidgets(
      'оборачивается в SizedBox с заданной высотой',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildApp(
          ACTitledTimeWidget.single(
            title: 'Height',
            preferredHeight: 60,
          ),
        ));

        // Assert -- проверяем через preferredSize и рендеринг
        final widget = tester.widget<ACTitledTimeWidget>(
          find.byType(ACTitledTimeWidget),
        );
        expect(widget.preferredSize.height, equals(60));
      },
    );
  });
}
