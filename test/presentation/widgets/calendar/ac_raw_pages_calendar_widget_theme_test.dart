import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final range = ACDateRange(
    min: DateTime(2024),
    max: DateTime(2025, 12),
  );

  late ACLightCalendarThemeData customTheme;

  setUp(() {
    customTheme = ACLightCalendarThemeData(
      weekTheme: ACLightWeekThemeData(
        textColor: const Color(0xFF112233),
      ),
      dayTheme: ACLightDayThemeData(
        textColor: const Color(0xFF445566),
      ),
      pagesCalendarHeaderTheme: ACLightPagesCalendarHeaderThemeData(
        monthTextColor: const Color(0xFFAABBCC),
      ),
      monthPickerTheme: ACLightMonthPickerThemeData(
        selectionColor: const Color(0xFFDDEEFF),
      ),
      wheelPickerTheme: ACLightWheelPickerThemeData(
        selectedItemTextColor: const Color(0xFF001122),
      ),
    );
  });

  Widget buildWidget({
    ACCalendarThemeData? theme,
    DateTime? initialMonth,
  }) =>
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: ACCalendarScope(
              dateRange: range,
              child: ACRawPagesCalendarWidget(
                range: range,
                initialMonth: initialMonth,
                theme: theme,
              ),
            ),
          ),
        ),
      );

  group('ACRawPagesCalendarWidget -- проброс weekTheme', () {
    testWidgets(
      'передаёт weekTheme из theme в ACWeekWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final weekWidget = tester.widget<ACWeekWidget>(
          find.byType(ACWeekWidget),
        );
        expect(weekWidget.theme, equals(customTheme.weekTheme));
      },
    );

    testWidgets(
      'ACWeekWidget получает null theme если theme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final weekWidget = tester.widget<ACWeekWidget>(
          find.byType(ACWeekWidget),
        );
        expect(weekWidget.theme, isNull);
      },
    );
  });

  group('ACRawPagesCalendarWidget -- проброс pagesCalendarHeaderTheme', () {
    testWidgets(
      'передаёт pagesCalendarHeaderTheme из theme в ACPagesCalendarHeader',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final header = tester.widget<ACPagesCalendarHeader>(
          find.byType(ACPagesCalendarHeader),
        );
        expect(
          header.theme,
          equals(customTheme.pagesCalendarHeaderTheme),
        );
      },
    );

    testWidgets(
      'ACPagesCalendarHeader получает null theme если theme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final header = tester.widget<ACPagesCalendarHeader>(
          find.byType(ACPagesCalendarHeader),
        );
        expect(header.theme, isNull);
      },
    );
  });

  group('ACRawPagesCalendarWidget -- проброс dayTheme', () {
    testWidgets(
      'передаёт dayTheme из theme в ACMonthWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget).first,
        );
        expect(monthWidget.dayTheme, equals(customTheme.dayTheme));
      },
    );

    testWidgets(
      'ACMonthWidget получает null dayTheme если theme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final monthWidget = tester.widget<ACMonthWidget>(
          find.byType(ACMonthWidget).first,
        );
        expect(monthWidget.dayTheme, isNull);
      },
    );
  });

  group(
      'ACRawPagesCalendarWidget -- проброс monthPickerTheme и wheelPickerTheme',
      () {
    testWidgets(
      'передаёт monthPickerTheme и wheelPickerTheme в ACMonthPicker при открытии',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Act -- нажимаем на заголовок месяца, чтобы открыть month picker
        final headerRow = find.byType(ACPagesCalendarHeader);
        expect(headerRow, findsOneWidget);

        // Находим GestureDetector внутри заголовка для открытия picker
        final gestureDetector = find.descendant(
          of: headerRow,
          matching: find.byType(GestureDetector),
        );
        await tester.tap(gestureDetector.first);
        await tester.pumpAndSettle();

        // Assert
        final monthPicker = tester.widget<ACMonthPicker>(
          find.byType(ACMonthPicker),
        );
        expect(
          monthPicker.monthPickerTheme,
          equals(customTheme.monthPickerTheme),
        );
        expect(
          monthPicker.wheelPickerTheme,
          equals(customTheme.wheelPickerTheme),
        );
      },
    );
  });
}
