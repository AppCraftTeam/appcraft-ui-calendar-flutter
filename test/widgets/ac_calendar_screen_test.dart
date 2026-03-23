import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  Widget buildWidget({
    ACDateRange? customRange,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    DateTime? initialDate,
    void Function(DateTime)? onVisibleDateChanged,
    PreferredSizeWidget? timeWidget,
    EdgeInsetsGeometry? scrollViewPadding,
    EdgeInsetsGeometry? weekPadding,
    EdgeInsetsGeometry? timeWidgetPadding,
    Color? titleColor,
    TextStyle? titleTextStyle,
    Color? backgroundColor,
  }) =>
      MaterialApp(
        theme: ThemeData(extensions: [
          ACCalendarThemeExtension(data: theme ?? ACLightCalendarThemeData())
        ]),
        home: ACCalendarScreen(
          range: customRange ?? range,
          theme: theme,
          selectController: selectController,
          initialDate: initialDate,
          onVisibleDateChanged: onVisibleDateChanged,
          timeWidget: timeWidget,
          scrollViewPadding: scrollViewPadding,
          weekPadding: weekPadding,
          timeWidgetPadding: timeWidgetPadding,
          titleColor: titleColor,
          titleTextStyle: titleTextStyle,
          backgroundColor: backgroundColor,
        ),
      );

  group('ACCalendarScreen -- рендеринг', () {
    testWidgets(
      'отображается корректно с минимальными параметрами',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarScreen), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
      },
    );

    testWidgets(
      'содержит AppBar с годом',
      (tester) async {
        // Arrange
        final initialDate = DateTime(2024, 6);

        // Act
        await tester.pumpWidget(buildWidget(initialDate: initialDate));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('2024'), findsOneWidget);
      },
    );

    testWidgets(
      'содержит ACRawCalendarWidget и ACCalendarScope',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACRawCalendarWidget), findsOneWidget);
        expect(find.byType(ACCalendarScope), findsOneWidget);
      },
    );

    testWidgets(
      'содержит ACWeekWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- initialDate', () {
    testWidgets(
      'использует текущую дату если initialDate не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget());
        await tester.pumpAndSettle();

        // Assert
        final now = DateTime.now();
        expect(find.text('${now.year}'), findsOneWidget);
      },
    );

    testWidgets(
      'отображает год переданного initialDate',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2025, 3)));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('2025'), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- стилизация', () {
    testWidgets(
      'применяет пользовательский цвет заголовка',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          titleColor: Colors.red,
        ));
        await tester.pumpAndSettle();

        // Assert
        final textWidget = tester.widget<Text>(find.text('2024'));
        expect(textWidget.style?.color, equals(Colors.red));
      },
    );

    testWidgets(
      'применяет пользовательский стиль заголовка',
      (tester) async {
        // Arrange
        const customStyle =
            TextStyle(fontSize: 30, fontWeight: FontWeight.w400);

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          titleTextStyle: customStyle,
        ));
        await tester.pumpAndSettle();

        // Assert
        final textWidget = tester.widget<Text>(find.text('2024'));
        expect(textWidget.style?.fontSize, equals(30));
      },
    );

    testWidgets(
      'применяет пользовательский цвет фона',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          backgroundColor: Colors.blue,
        ));
        await tester.pumpAndSettle();

        // Assert
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, equals(Colors.blue));
      },
    );
  });

  group('ACCalendarScreen -- timeWidget', () {
    testWidgets(
      'отображает timeWidget',
      (tester) async {
        // Arrange
        final timeWidget = ACTitledTimeWidget.single(title: 'Time');

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          timeWidget: timeWidget,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Time'), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- onVisibleDateChanged', () {
    testWidgets(
      'виджет создаётся с callback',
      (tester) async {
        // Arrange
        final dates = <DateTime>[];

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          onVisibleDateChanged: dates.add,
        ));
        await tester.pumpAndSettle();

        // Assert -- виджет рендерится корректно
        expect(find.byType(ACCalendarScreen), findsOneWidget);
      },
    );
  });

  group('ACCalendarScreen -- selectController', () {
    testWidgets(
      'работает с внешним selectController',
      (tester) async {
        // Arrange
        final controller = ACCalendarSingleSelectController();

        // Act
        await tester.pumpWidget(buildWidget(
          initialDate: DateTime(2024, 6),
          selectController: controller,
        ));
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(ACCalendarScreen), findsOneWidget);

        controller.dispose();
      },
    );
  });

  group('ACCalendarScreen -- year в AppBar обёрнут в GestureDetector', () {
    testWidgets(
      'GestureDetector оборачивает текст года',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Assert
        final yearText = find.text('2024');
        final gestureDetector = find.ancestor(
          of: yearText,
          matching: find.byType(GestureDetector),
        );
        expect(gestureDetector, findsAtLeastNWidgets(1));
      },
    );
  });

  group('ACCalendarScreen -- dispose', () {
    testWidgets(
      'корректно удаляется из дерева виджетов',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(initialDate: DateTime(2024, 6)));
        await tester.pumpAndSettle();

        // Act
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert
        expect(find.byType(ACCalendarScreen), findsNothing);
      },
    );
  });
}
