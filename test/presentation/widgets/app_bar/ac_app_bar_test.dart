import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp({
    Widget? title,
    List<Widget>? actions,
    Color? backgroundColor,
    Color? surfaceTintColor,
    TextStyle? titleTextStyle,
    bool? centerTitle,
    bool? automaticallyImplyLeading,
    double? scrolledUnderElevation,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: ACAppBar(
          title: title,
          actions: actions,
          backgroundColor: backgroundColor,
          surfaceTintColor: surfaceTintColor,
          titleTextStyle: titleTextStyle,
          centerTitle: centerTitle,
          automaticallyImplyLeading: automaticallyImplyLeading,
          scrolledUnderElevation: scrolledUnderElevation,
        ),
      ),
    );
  }

  group('ACAppBar -- preferredSize', () {
    test('preferredSize equals Size.fromHeight(kToolbarHeight)', () {
      // Arrange
      const appBar = ACAppBar();

      // Act
      final size = appBar.preferredSize;

      // Assert
      expect(size, const Size.fromHeight(kToolbarHeight));
    });
  });

  group('ACAppBar -- T003 [US1]: defaults without parameters', () {
    testWidgets('automaticallyImplyLeading defaults to false', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildApp());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.automaticallyImplyLeading, isFalse);
    });

    testWidgets('centerTitle defaults to false', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildApp());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isFalse);
    });

    testWidgets('scrolledUnderElevation defaults to 0', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildApp());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.scrolledUnderElevation, 0);
    });

    testWidgets('surfaceTintColor defaults to Colors.transparent',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildApp());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.surfaceTintColor, Colors.transparent);
    });

    testWidgets('backgroundColor defaults to scaffoldBackgroundColor',
        (tester) async {
      // Arrange
      const scaffoldColor = Color(0xFFAABBCC);
      final theme = ThemeData(scaffoldBackgroundColor: scaffoldColor);

      // Act
      await tester.pumpWidget(buildApp(theme: theme));

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, scaffoldColor);
    });

    testWidgets(
        'titleTextStyle defaults to fontSize 17, fontWeight w600, color black',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(buildApp());

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.titleTextStyle?.fontSize, 17);
      expect(appBar.titleTextStyle?.fontWeight, FontWeight.w600);
      expect(appBar.titleTextStyle?.color, const Color(0xFF000000));
    });
  });

  group('ACAppBar -- T004 [US1]: title is displayed', () {
    testWidgets('renders title text widget', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildApp(title: const Text('Test')),
      );

      // Assert
      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('ACAppBar -- T007 [US2]: custom backgroundColor', () {
    testWidgets('uses provided backgroundColor instead of default',
        (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildApp(backgroundColor: Colors.red),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, Colors.red);
    });
  });

  group('ACAppBar -- T008 [US2]: actions', () {
    testWidgets('renders action widgets', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildApp(
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text('Done'),
            ),
          ],
        ),
      );

      // Assert
      expect(find.text('Done'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('ACAppBar -- T009 [US2]: centerTitle true', () {
    testWidgets('passes centerTitle true to inner AppBar', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        buildApp(centerTitle: true),
      );

      // Assert
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.centerTitle, isTrue);
    });
  });
}
