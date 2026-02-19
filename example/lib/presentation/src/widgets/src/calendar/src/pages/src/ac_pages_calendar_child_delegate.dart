import 'package:flutter/material.dart';

import '../../../../../../../../data/data.dart';
import '../../../../../../../presentation.dart';

/// Абстрактный делегат для построения элементов [ACPagesCalendarWidget].
///
/// Определяет интерфейс для построения виджета месяца и вычисления его высоты.
abstract class ACPagesCalendarChildDelegate {
  const ACPagesCalendarChildDelegate();

  /// Построение виджета для месяца.
  ///
  /// [context] - контекст для построения виджета
  /// [monthDate] - дата месяца (первый день месяца)
  Widget buildItem(BuildContext context, DateTime monthDate);

  /// Вычисление высоты элемента
  ///
  /// [constraints] - ограничения размера
  double buildItemHeight(BoxConstraints constraints);
}

/// Стандартная реализация [ACPagesCalendarChildDelegate].
///
/// Отображает месяц в виде сетки дней с поддержкой выбора дат и темы.
/// Кэширует список дней для каждого месяца (LRU, до 12 месяцев).
class ACDefaultPagesCalendarChildDelegate extends ACPagesCalendarChildDelegate {
  ACDefaultPagesCalendarChildDelegate({
    this.onShouldSelect,
    this.weekStart,
    this.theme
  });

  /// Предикат доступности дня для выбора.
  /// Если не задан, все дни текущего месяца считаются доступными.
  /// Вызывается только для дней текущего месяца — проверку принадлежности месяцу
  /// выполняет [ACDefaultDaysMonthChildDelegate] через [ACDayMonthPosition].
  final bool Function(DateTime day)? onShouldSelect;

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  final int? weekStart;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  final _layout = ACDefaultMonthLayout.mainAxisCount6;
  final _calendarRepository = const ACCalendarRepository();

  /// Кэш списка дней для каждого месяца (LRU, до 12 месяцев)
  final _daysCache = ACCache<DateTime, List<DateTime>>(12);

  List<DateTime> _getDays(DateTime monthDate) =>
    _daysCache.putIfAbsent(monthDate, () =>
      _calendarRepository.getMonthDays(monthDate, weekStart: weekStart),
    );

  @override
  Widget buildItem(BuildContext context, DateTime monthDate) =>
    RepaintBoundary(
      child: ACMonthWidget(
        layout: _layout,
        childrenDelegate: ACDefaultDaysMonthChildDelegate(
          days: _getDays(monthDate),
          monthDate: monthDate,
          onShouldSelect: onShouldSelect,
          dayTheme: theme?.dayTheme
        ),
      ),
    );

  @override
  double buildItemHeight(BoxConstraints constraints) =>
    _layout.calculateHeight(constraints.maxWidth);
}
