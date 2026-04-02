import 'dart:ui';

import 'package:appcraft_ui_calendar_flutter/appcraft_ui_calendar_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('applyBoldText', () {
    group('boldText == true', () {
      testWidgets(
        'w400 maps to w700',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w400);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w700);
        },
      );

      testWidgets(
        'w500 maps to w700',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w500);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w700);
        },
      );

      testWidgets(
        'w600 maps to w800',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w600);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w800);
        },
      );

      testWidgets(
        'w700 maps to w900',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w700);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w900);
        },
      );

      testWidgets(
        'w800 maps to w900',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w800);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w900);
        },
      );

      testWidgets(
        'w900 stays w900',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w900);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w900);
        },
      );

      testWidgets(
        'null fontWeight defaults to w400 and maps to w700',
        (tester) async {
          // Arrange
          const style = TextStyle();

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w700);
        },
      );

      testWidgets(
        'preserves other TextStyle properties',
        (tester) async {
          // Arrange
          const style = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Color(0xFF112233),
            letterSpacing: 1.5,
            height: 1.2,
          );

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: true),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w700);
          expect(result.fontSize, 16);
          expect(result.color, const Color(0xFF112233));
          expect(result.letterSpacing, 1.5);
          expect(result.height, 1.2);
        },
      );
    });

    group('boldText == false', () {
      testWidgets(
        'returns style unchanged',
        (tester) async {
          // Arrange
          const style = TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFFAABBCC),
          );

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: false),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result, style);
        },
      );

      testWidgets(
        'does not modify fontWeight',
        (tester) async {
          // Arrange
          const style = TextStyle(fontWeight: FontWeight.w500);

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: false),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, FontWeight.w500);
        },
      );

      testWidgets(
        'null fontWeight remains null',
        (tester) async {
          // Arrange
          const style = TextStyle();

          // Act
          late final TextStyle result;
          await tester.pumpWidget(
            MediaQuery(
              data: const MediaQueryData(boldText: false),
              child: Builder(
                builder: (context) {
                  result = applyBoldText(style, context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          // Assert
          expect(result.fontWeight, isNull);
        },
      );
    });
  });
}
