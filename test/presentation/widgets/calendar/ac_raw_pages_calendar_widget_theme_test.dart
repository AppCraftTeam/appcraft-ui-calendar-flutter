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

  group('ACRawPagesCalendarWidget -- forwarding weekTheme', () {
    testWidgets(
      'forwards weekTheme from theme to ACWeekWidget',
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
      'ACWeekWidget receives null theme when theme is not provided',
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

  group('ACRawPagesCalendarWidget -- forwarding pagesCalendarHeaderTheme', () {
    testWidgets(
      'forwards pagesCalendarHeaderTheme from theme to ACPagesCalendarHeader',
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
      'ACPagesCalendarHeader receives null theme when theme is not provided',
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

  group('ACRawPagesCalendarWidget -- forwarding dayTheme', () {
    testWidgets(
      'forwards dayTheme from theme to ACMonthWidget',
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
      'ACMonthWidget receives null dayTheme when theme is not provided',
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
      'ACRawPagesCalendarWidget -- forwarding monthPickerTheme and wheelPickerTheme',
      () {
    testWidgets(
      'forwards monthPickerTheme and wheelPickerTheme to ACMonthPicker on open',
      (tester) async {
        // Arrange
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Act -- tap the month header to open the month picker
        final headerRow = find.byType(ACPagesCalendarHeader);
        expect(headerRow, findsOneWidget);

        // Find the GestureDetector inside the header to open the picker
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
          monthPicker.theme,
          equals(customTheme),
        );
      },
    );
  });
}
