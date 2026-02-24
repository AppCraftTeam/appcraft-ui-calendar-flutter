import 'package:flutter/material.dart';

import '../../../../../presentation.dart';

/// Абстрактный делегат для построения элементов [ACPagesCalendarWidget].
///
/// Определяет интерфейс для построения виджета месяца и вычисления его высоты.
abstract class ACPagesCalendarChildDelegate {
  const ACPagesCalendarChildDelegate();

  /// Построение виджета для месяца.
  ///
  /// [context] - контекст для построения виджета
  /// [monthDate] - дата месяца (первый день месяца)
  /// [days] - список дней для отображения в сетке месяца,
  /// включая дни из соседних месяцев для заполнения первой и последней недель
  Widget buildItem(BuildContext context, DateTime monthDate, List<DateTime> days);

  /// Вычисление высоты элемента
  ///
  /// [constraints] - ограничения размера
  double buildItemHeight(BoxConstraints constraints);
}

/// Стандартная реализация [ACPagesCalendarChildDelegate].
///
/// Отображает месяц в виде сетки дней.
/// Тема, диапазон дат и контроллер выбора берутся из [ACCalendarScope].
class ACDefaultPagesCalendarChildDelegate extends ACPagesCalendarChildDelegate {
  const ACDefaultPagesCalendarChildDelegate();

  ACDefaultMonthLayout get _layout => ACDefaultMonthLayout.mainAxisCount6;

  @override
  Widget buildItem(BuildContext context, DateTime monthDate, List<DateTime> days) =>
    RepaintBoundary(
      child: ACMonthWidget(
        layout: _layout,
        childrenDelegate: ACDefaultDaysMonthChildDelegate(
          days: days,
          monthDate: monthDate,
        ),
      ),
    );

  @override
  double buildItemHeight(BoxConstraints constraints) =>
    _layout.calculateHeight(constraints.maxWidth);
}
