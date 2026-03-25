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
            child: ACPagesCalendarWidget(
              range: range,
              theme: theme,
              initialMonth: initialMonth,
            ),
          ),
        ),
      );

  group('ACPagesCalendarWidget -- проброс theme в ACRawPagesCalendarWidget',
      () {
    testWidgets(
      'передаёт theme в ACRawPagesCalendarWidget',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          theme: customTheme,
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.theme, equals(customTheme));
      },
    );

    testWidgets(
      'ACRawPagesCalendarWidget получает null theme если theme не передан',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(buildWidget(
          initialMonth: DateTime(2024, 6),
        ));
        await tester.pumpAndSettle();

        // Assert
        final rawWidget = tester.widget<ACRawPagesCalendarWidget>(
          find.byType(ACRawPagesCalendarWidget),
        );
        expect(rawWidget.theme, isNull);
      },
    );

    testWidgets(
      'weekTheme доходит до ACWeekWidget через ACRawPagesCalendarWidget',
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
      'pagesCalendarHeaderTheme доходит до ACPagesCalendarHeader',
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
      'dayTheme доходит до ACMonthWidget через ACRawPagesCalendarWidget',
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
  });
}
