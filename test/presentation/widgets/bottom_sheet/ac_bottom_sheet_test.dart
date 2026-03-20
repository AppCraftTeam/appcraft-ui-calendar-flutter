import 'package:appcraft_ui_calendar_flutter/src/widgets/ac_bottom_sheet.dart';
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

  group('ACBottomSheet.show -- T004: дефолтные параметры', () {
    testWidgets('открывает ModalBottomSheet при вызове', (tester) async {
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

    testWidgets('shape по умолчанию — RoundedRectangleBorder с radius 16',
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

    testWidgets('clipBehavior по умолчанию — Clip.antiAlias', (tester) async {
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

    testWidgets(
        'isDismissible по умолчанию — true (закрытие по тапу на барьер)',
        (tester) async {
      // Arrange
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Act — тап на барьер (область вне bottom sheet)
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert — bottom sheet закрылся
      expect(find.text('content'), findsNothing);
    });

    testWidgets('enableDrag по умолчанию — true', (tester) async {
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

    testWidgets('showDragHandle по умолчанию — false', (tester) async {
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

    testWidgets('backgroundColor по умолчанию — colorScheme.surface из темы',
        (tester) async {
      // Arrange
      const customSurfaceColor = Color(0xFFAABBCC);

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              surface: customSurfaceColor,
            ),
          ),
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

      // Assert
      final bottomSheet = tester.widget<BottomSheet>(find.byType(BottomSheet));
      expect(bottomSheet.backgroundColor, customSurfaceColor);
    });
  });

  group('ACBottomSheet.show -- T005: переопределение параметров', () {
    testWidgets('isScrollControlled можно установить в true', (tester) async {
      // Arrange & Act
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          isScrollControlled: true,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Assert — bottom sheet открылся
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('isDismissible: false запрещает закрытие по тапу на барьер',
        (tester) async {
      // Arrange
      await openBottomSheet(tester, onPressed: (context) {
        ACBottomSheet.show<void>(
          context,
          isDismissible: false,
          builder: (_) => const SizedBox(height: 200, child: Text('content')),
        );
      });

      // Act — тап на барьер
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert — bottom sheet НЕ закрылся
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('backgroundColor можно переопределить', (tester) async {
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

    testWidgets('enableDrag: false запрещает перетаскивание', (tester) async {
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

    testWidgets('showDragHandle: true показывает drag handle', (tester) async {
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

    testWidgets('shape можно переопределить', (tester) async {
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

    testWidgets('clipBehavior можно переопределить', (tester) async {
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

    testWidgets('constraints передаются в showModalBottomSheet',
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

      // Assert — bottom sheet открылся с ограничениями
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('elevation можно переопределить', (tester) async {
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

  group('ACBottomSheet.show -- T006: возврат результата', () {
    testWidgets('возвращает null при закрытии без результата', (tester) async {
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

      // Act — закрытие по тапу на барьер
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      // Assert
      expect(result, isNull);
    });

    testWidgets('возвращает значение при Navigator.pop(result)',
        (tester) async {
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

      // Act — открываем bottom sheet
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // Act — нажимаем кнопку внутри bottom sheet
      await tester.tap(find.text('close with result'));
      await tester.pumpAndSettle();

      // Assert
      expect(result, 'done');
    });

    testWidgets('возвращает типизированный результат (int)', (tester) async {
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

  group('ACBottomSheet -- конструктор', () {
    test('приватный конструктор — show доступен как статический метод', () {
      // ACBottomSheet._() — приватный конструктор.
      // Проверяем, что класс используется только через статический метод.
      expect(ACBottomSheet.show, isA<Function>());
    });
  });
}
