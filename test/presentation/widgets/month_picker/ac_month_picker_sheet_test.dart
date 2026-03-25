import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ru'));

  final range = ACDateRange(
    min: DateTime(2020, 1, 1),
    max: DateTime(2030, 12, 31),
  );

  Widget buildApp({required Widget child}) => MaterialApp(
        home: Scaffold(body: child),
      );

  group(
      'T010: ACMonthPickerSheet.show() opens bottom sheet with correct content',
      () {
    testWidgets('opens a bottom sheet containing ACMonthPicker',
        (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(context, range: range),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ACMonthPickerSheet), findsOneWidget);
      expect(find.byType(ACMonthPicker), findsOneWidget);
    });

    testWidgets('bottom sheet has shape with radius 16', (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(context, range: range),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert: BottomSheet widget has the expected shape
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.shape, isA<RoundedRectangleBorder>());
      final shape = bottomSheet.shape! as RoundedRectangleBorder;
      expect(
        shape.borderRadius,
        const BorderRadius.vertical(top: Radius.circular(16)),
      );
    });

    testWidgets('bottom sheet has clipBehavior antiAlias', (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(context, range: range),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.clipBehavior, Clip.antiAlias);
    });

    testWidgets('passes initialDate to ACMonthPickerSheet widget',
        (tester) async {
      // Arrange
      final initialDate = DateTime(2025, 6, 1);
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(
              context,
              range: range,
              initialDate: initialDate,
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.initialDate, initialDate);
    });

    testWidgets('passes onDateChanged callback to sheet widget',
        (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(
              context,
              range: range,
              onDateChanged: (date) {},
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert: the sheet widget received the callback
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.onDateChanged, isNotNull);
    });

    testWidgets('passes pickerHeight to ACMonthPickerSheet widget',
        (tester) async {
      // Arrange
      const pickerHeight = 300.0;
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(
              context,
              range: range,
              pickerHeight: pickerHeight,
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.pickerHeight, pickerHeight);
    });
  });

  group('T011: ACMonthPickerSheet.show() public signature is stable', () {
    testWidgets('accepts all named parameters without error', (tester) async {
      // Arrange: prepare all optional parameters
      final initialDate = DateTime(2025, 3, 1);
      final theme = ACLightCalendarThemeData();

      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(
              context,
              range: range,
              initialDate: initialDate,
              onDateChanged: (date) {},
              onDone: (date) {},
              locale: 'ru',
              theme: theme,
              pickerHeight: 150,
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert: sheet opened successfully with all parameters passed through
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.range, range);
      expect(sheet.initialDate, initialDate);
      expect(sheet.onDateChanged, isNotNull);
      expect(sheet.onDone, isNotNull);
      expect(sheet.locale, 'ru');
      expect(sheet.theme, theme);
      expect(sheet.pickerHeight, 150);
    });

    testWidgets('works with only required parameter (range)', (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(context, range: range),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.range, range);
      expect(sheet.initialDate, isNull);
      expect(sheet.onDateChanged, isNull);
      expect(sheet.onDone, isNull);
      expect(sheet.locale, isNull);
      expect(sheet.localizationManager, isNull);
      expect(sheet.theme, isNull);
      expect(sheet.pickerHeight, isNull);
    });

    testWidgets('accepts localizationManager parameter', (tester) async {
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACMonthPickerSheet.show(
              context,
              range: range,
              localizationManager: const ACDefaultLocalizationManager(),
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      final sheet = tester.widget<ACMonthPickerSheet>(
        find.byType(ACMonthPickerSheet),
      );
      expect(sheet.localizationManager, isA<ACDefaultLocalizationManager>());
    });
  });
}
