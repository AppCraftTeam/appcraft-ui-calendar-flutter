import 'package:flutter/material.dart';

/// Абстрактный layout для месячного представления календаря.
///
/// Наследует [MultiChildLayoutDelegate] и добавляет метод [calculateHeight]
/// для вычисления высоты сетки по заданной ширине.
abstract class ACMonthLayout extends MultiChildLayoutDelegate {
  ACMonthLayout();

  /// Вычисляет высоту сетки месяца для заданной [width].
  double calculateHeight(double width);
}

/// Стандартный layout месяца в виде равномерной сетки дней.
///
/// Размещает дни в сетке [mainAxisCount] × [crossAxisCount] (строки × столбцы).
/// По умолчанию — 6 строк по 7 столбцов (стандартный вид месяца).
class ACDefaultMonthLayout extends ACMonthLayout {
  ACDefaultMonthLayout({
    this.crossAxisCount = 7,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.mainAxisCount = 6,
    this.textScaler = TextScaler.noScaling,
  });

  /// Количество столбцов (дней в неделе). По умолчанию 7.
  final int crossAxisCount;

  /// Горизонтальный отступ между ячейками.
  final double crossAxisSpacing;

  /// Вертикальный отступ между строками.
  final double mainAxisSpacing;

  /// Соотношение ширины к высоте ячейки. По умолчанию 1.0 (квадрат).
  final double childAspectRatio;

  /// Количество строк (недель) в месяце.
  final int mainAxisCount;

  /// Масштабирование текста, влияющее на высоту ячеек.
  ///
  /// По умолчанию [TextScaler.noScaling] — высота не масштабируется.
  final TextScaler textScaler;

  /// Предустановленный layout для месяца из 4 недель.
  static final mainAxisCount4 = ACDefaultMonthLayout(mainAxisCount: 4);

  /// Предустановленный layout для месяца из 5 недель.
  static final mainAxisCount5 = ACDefaultMonthLayout(mainAxisCount: 5);

  /// Предустановленный layout для месяца из 6 недель.
  static final mainAxisCount6 = ACDefaultMonthLayout(mainAxisCount: 6);

  @override
  double calculateHeight(double width) {
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    final scaledItemHeight = textScaler.scale(itemHeight);
    return (scaledItemHeight * mainAxisCount) +
        (mainAxisSpacing * (mainAxisCount - 1));
  }

  @override
  void performLayout(Size size) {
    // Вычисляем размер одного элемента
    final maxCrossAxisSpacing = (crossAxisCount - 1) * crossAxisSpacing;
    final itemWidth = (size.width - maxCrossAxisSpacing) / crossAxisCount;
    final itemHeight = itemWidth / childAspectRatio;
    final scaledItemHeight = textScaler.scale(itemHeight);

    // Размещаем каждый элемент в соответствующей позиции сетки
    var childIndex = 0;
    while (hasChild(childIndex)) {
      final row = childIndex ~/ crossAxisCount;
      final col = childIndex % crossAxisCount;

      final x = col * (itemWidth + crossAxisSpacing);
      final y = row * (scaledItemHeight + mainAxisSpacing);

      layoutChild(
        childIndex,
        BoxConstraints.tight(Size(itemWidth, scaledItemHeight)),
      );
      positionChild(childIndex, Offset(x, y));

      childIndex++;
    }
  }

  @override
  bool shouldRelayout(ACDefaultMonthLayout oldDelegate) =>
      crossAxisCount != oldDelegate.crossAxisCount ||
      crossAxisSpacing != oldDelegate.crossAxisSpacing ||
      mainAxisSpacing != oldDelegate.mainAxisSpacing ||
      childAspectRatio != oldDelegate.childAspectRatio ||
      mainAxisCount != oldDelegate.mainAxisCount ||
      textScaler != oldDelegate.textScaler;
}
