import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Suppresses RenderFlex overflow errors during the callback.
/// This allows testing that widgets render without crashing
/// even when layout overflow occurs at extreme scale factors.
Future<void> ignoreOverflowErrors(Future<void> Function() callback) async {
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    final isOverflow = details.exceptionAsString().contains('overflowed');
    if (!isOverflow) {
      originalOnError?.call(details);
    }
  };
  try {
    await callback();
  } finally {
    FlutterError.onError = originalOnError;
  }
}

void main() {
  group('Extreme textScaleFactor=3.5', () {
    Widget wrapWithScale(Widget child) {
      return MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(3.5),
        ),
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets(
      'ACWeekWidget рендерится без crash при scale=3.5',
      (tester) async {
        // Arrange & Act
        await ignoreOverflowErrors(() async {
          await tester.pumpWidget(
            wrapWithScale(const ACWeekWidget()),
          );
        });

        // Assert -- widget tree is built, no crash
        expect(find.byType(ACWeekWidget), findsOneWidget);
      },
    );

    testWidgets(
      'ACPagesCalendarHeader рендерится без crash при scale=3.5',
      (tester) async {
        // Arrange & Act
        await ignoreOverflowErrors(() async {
          await tester.pumpWidget(
            wrapWithScale(
              ACPagesCalendarHeader(monthDate: DateTime(2024, 3, 1)),
            ),
          );
        });

        // Assert -- widget tree is built, no crash
        expect(find.byType(ACPagesCalendarHeader), findsOneWidget);
      },
    );

    testWidgets(
      'ACDayWidget рендерится без crash при scale=3.5',
      (tester) async {
        // Arrange & Act
        await ignoreOverflowErrors(() async {
          await tester.pumpWidget(
            wrapWithScale(
              Center(child: ACDayWidget(dayDate: DateTime(2024, 3, 15))),
            ),
          );
        });

        // Assert -- widget tree is built, no crash
        expect(find.byType(ACDayWidget), findsOneWidget);
      },
    );
  });

  group('Narrow screen 280dp + textScaleFactor=2.0', () {
    testWidgets(
      'ACPagesCalendarHeader рендерится на узком экране 280dp',
      (tester) async {
        // Arrange
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        tester.view.physicalSize = const Size(280, 600);
        tester.view.devicePixelRatio = 1.0;

        // Act
        await ignoreOverflowErrors(() async {
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2),
              ),
              child: MaterialApp(
                home: Scaffold(
                  body: ACPagesCalendarHeader(
                    monthDate: DateTime(2024, 3, 1),
                  ),
                ),
              ),
            ),
          );
        });

        // Assert -- widget tree is built, no crash
        expect(find.byType(ACPagesCalendarHeader), findsOneWidget);
      },
    );
  });

  group('Bold text + textScaleFactor=2.0', () {
    Widget wrapWithBoldAndScale(Widget child) {
      return MediaQuery(
        data: const MediaQueryData(
          textScaler: TextScaler.linear(2),
          boldText: true,
        ),
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets(
      'ACDayWidget рендерится без exception при boldText + scale=2.0',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          wrapWithBoldAndScale(
            Center(child: ACDayWidget(dayDate: DateTime(2024, 3, 15))),
          ),
        );

        // Assert
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'ACWeekWidget рендерится без exception при boldText + scale=2.0',
      (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          wrapWithBoldAndScale(const ACWeekWidget()),
        );

        // Assert
        expect(tester.takeException(), isNull);
      },
    );
  });
}
