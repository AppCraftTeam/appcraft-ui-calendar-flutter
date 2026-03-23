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

  // Увеличиваем размер экрана, чтобы календарь помещался без overflow.
  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
  }

  group('T003 [US1]: show() opens bottom sheet with ACPagesCalendarWidget', () {
    testWidgets('opens a bottom sheet containing ACPagesCalendarWidget',
        (tester) async {
      setLargeScreen(tester);
      // Arrange
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACPagesCalendarSheet.show(context, range: range),
            child: const Text('Open'),
          ),
        ),
      ));

      // Act
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ACPagesCalendarSheet), findsOneWidget);
      expect(find.byType(ACPagesCalendarWidget), findsOneWidget);
    });
  });

  group('T004 [US1]: done button calls onDone and closes sheet', () {
    testWidgets('tapping done button invokes onDone callback and closes sheet',
        (tester) async {
      setLargeScreen(tester);
      // Arrange
      var onDoneCalled = false;
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACPagesCalendarSheet.show(
              context,
              range: range,
              locale: 'ru',
              onDone: () => onDoneCalled = true,
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ACPagesCalendarSheet), findsOneWidget);

      // Act
      await tester.tap(find.text('Готово'));
      await tester.pumpAndSettle();

      // Assert
      expect(onDoneCalled, isTrue);
      expect(find.byType(ACPagesCalendarSheet), findsNothing);
    });
  });

  group('T005 [US1]: closing by tapping outside does NOT call onDone', () {
    testWidgets('dismissing sheet without done button does not invoke onDone',
        (tester) async {
      setLargeScreen(tester);
      // Arrange
      var onDoneCalled = false;
      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACPagesCalendarSheet.show(
              context,
              range: range,
              onDone: () => onDoneCalled = true,
            ),
            child: const Text('Open'),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.byType(ACPagesCalendarSheet), findsOneWidget);

      // Act: tap outside the bottom sheet to dismiss
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      // Assert
      expect(onDoneCalled, isFalse);
      expect(find.byType(ACPagesCalendarSheet), findsNothing);
    });
  });

  group('T009 [US2]: public signature accepts all parameters', () {
    testWidgets('show() accepts all named parameters without error',
        (tester) async {
      setLargeScreen(tester);
      // Arrange
      final initialMonth = DateTime(2025, 6, 1);
      final theme = ACLightCalendarThemeData();
      final selectController = ACCalendarSingleSelectController();

      await tester.pumpWidget(buildApp(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => ACPagesCalendarSheet.show(
              context,
              range: range,
              repository: const ACDefaultCalendarRepository(),
              locale: 'ru',
              theme: theme,
              selectController: selectController,
              initialMonth: initialMonth,
              spacing: 8,
              onDone: () {},
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
      final sheet = tester.widget<ACPagesCalendarSheet>(
        find.byType(ACPagesCalendarSheet),
      );
      expect(sheet.range, range);
      expect(sheet.repository, isA<ACDefaultCalendarRepository>());
      expect(sheet.locale, 'ru');
      expect(sheet.theme, theme);
      expect(sheet.selectController, selectController);
      expect(sheet.initialMonth, initialMonth);
      expect(sheet.spacing, 8.0);
      expect(sheet.onDone, isNotNull);
      expect(sheet.localizationManager, isA<ACDefaultLocalizationManager>());

      // Cleanup
      selectController.dispose();
    });
  });

  group('T010 [US3]: renders as a widget directly', () {
    testWidgets('displays AppBar with title and done button', (tester) async {
      setLargeScreen(tester);
      // Arrange & Act
      await tester.pumpWidget(buildApp(
        child: ACPagesCalendarSheet(range: range, locale: 'ru'),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Готово'), findsOneWidget);
    });

    testWidgets('contains ACPagesCalendarWidget in the tree', (tester) async {
      setLargeScreen(tester);
      // Arrange & Act
      await tester.pumpWidget(buildApp(
        child: ACPagesCalendarSheet(range: range),
      ));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ACPagesCalendarSheet), findsOneWidget);
      expect(find.byType(ACPagesCalendarWidget), findsOneWidget);
    });
  });
}
