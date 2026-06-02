import 'package:appcraft_ui_calendar_flutter/src/presentation/src/widgets/src/bottom_sheet/src/ac_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openBottomSheet(
    WidgetTester tester, {
    required void Function(BuildContext context) onPressed,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => onPressed(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('ACBottomSheet.show -- T004: default parameters', () {
    testWidgets('opens ModalBottomSheet when called', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('default shape is RoundedRectangleBorder with radius 16',
        (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.shape, isNotNull);
      expect(
        bottomSheet.shape,
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      );
    });

    testWidgets('default clipBehavior is Clip.antiAlias', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.clipBehavior, Clip.antiAlias);
    });

    testWidgets('default isDismissible is true (closes on barrier tap)',
        (tester) async {
      // Arrange
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Act — tap on the barrier (area outside the bottom sheet)
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert — bottom sheet closed
      expect(find.text('content'), findsNothing);
    });

    testWidgets('default enableDrag is true', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.enableDrag, isTrue);
    });

    testWidgets('default showDragHandle is false', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.showDragHandle, isFalse);
    });

    testWidgets('default backgroundColor comes from ACCalendarThemeExtension',
        (tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  ACBottomSheet.show<void>(
                    context,
                    builder: (_) =>
                        const SizedBox(height: 200, child: Text('content')),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Assert — default backgroundColor from ACLightCalendarThemeData
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.backgroundColor, const Color(0xFFFFFFFF));
    });
  });

  group('ACBottomSheet.show -- T005: parameter overrides', () {
    testWidgets('isScrollControlled can be set to true', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          isScrollControlled: true,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert — bottom sheet opened
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('isDismissible: false prevents closing on barrier tap',
        (tester) async {
      // Arrange
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          isDismissible: false,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Act — tap on the barrier
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert — bottom sheet did NOT close
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('backgroundColor can be overridden', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          backgroundColor: Colors.red,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.backgroundColor, Colors.red);
    });

    testWidgets('enableDrag: false prevents dragging', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          enableDrag: false,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.enableDrag, isFalse);
    });

    testWidgets('showDragHandle: true shows drag handle', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          showDragHandle: true,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.showDragHandle, isTrue);
    });

    testWidgets('shape can be overridden', (tester) async {
      // Arrange
      const customShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      );

      // Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          shape: customShape,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.shape, customShape);
    });

    testWidgets('clipBehavior can be overridden', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          clipBehavior: Clip.hardEdge,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.clipBehavior, Clip.hardEdge);
    });

    testWidgets('constraints are passed to showModalBottomSheet',
        (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          isScrollControlled: true,
          constraints: const BoxConstraints(maxHeight: 300),
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert — bottom sheet opened with constraints
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('elevation can be overridden', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          elevation: 8,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.elevation, 8);
    });
  });

  group('ACBottomSheet.show -- T006: returning a result', () {
    testWidgets('returns null when closed without a result', (tester) async {
      // Arrange
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ACBottomSheet.show<String>(
                    context,
                    builder: (_) =>
                        const SizedBox(height: 200, child: Text('content')),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Act — close by tapping on the barrier
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert
      expect(result, isNull);
    });

    testWidgets('returns a value on Navigator.pop(result)', (tester) async {
      // Arrange
      String? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ACBottomSheet.show<String>(
                    context,
                    builder: (BuildContext sheetContext) => ElevatedButton(
                      onPressed: () => Navigator.of(sheetContext).pop('done'),
                      child: const Text('close with result'),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      // Act — open the bottom sheet
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Act — press the button inside the bottom sheet
      await tester.tap(find.text('close with result'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, 'done');
    });

    testWidgets('returns a typed result (int)', (tester) async {
      // Arrange
      int? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await ACBottomSheet.show<int>(
                    context,
                    builder: (BuildContext sheetContext) => ElevatedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(42),
                      child: const Text('close with int'),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('close with int'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, 42);
    });
  });

  group('ACBottomSheet -- constructor', () {
    test('private constructor -- show is available as a static method', () {
      // ACBottomSheet._() — private constructor.
      // Verify that the class is used only through the static method.
      expect(ACBottomSheet.show, isA<Function>());
    });
  });
}
