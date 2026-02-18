import 'package:flutter/material.dart';

import '../../../../../../../../data/data.dart';
import '../../../../../../../../domain/domain.dart';
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

  /// Вычисление высоты элемента.
  ///
  /// [itemWidth] - ширина контейнера элемента
  double itemHeight(double itemWidth);
}

/// Стандартная реализация [ACPagesCalendarChildDelegate].
///
/// Отображает месяц в виде сетки дней с поддержкой выбора дат и темы.
/// Кэширует список дней для каждого месяца (LRU, до 12 месяцев).
class ACDefaultPagesCalendarChildDelegate extends ACPagesCalendarChildDelegate {
  ACDefaultPagesCalendarChildDelegate({
    required this.range,
    this.weekStart,
    this.theme,
    this.onSelectStateForDay,
    this.onSelectDay,
  });

  /// Диапазон доступных дат календаря
  final ACDateRange range;

  /// Первый день недели (0 - воскресенье, 1 - понедельник и т.д.)
  final int? weekStart;

  /// Тема календаря
  final ACCalendarThemeData? theme;

  /// Функция определения состояния выбора для конкретного дня
  final ACDaySelectState? Function(DateTime day)? onSelectStateForDay;

  /// Коллбэк при выборе дня
  final void Function(DateTime day)? onSelectDay;

  final _calendarRepository = const ACCalendarRepository();
  final _monthLayout = ACDefaultMonthLayout.mainAxisCount6;

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
        layout: _monthLayout,
        childrenDelegate: ACDefaultDaysMonthChildDelegate(
          days: _getDays(monthDate),
          onShouldSelect: (day) {
            final isDayInRange = !day.isBefore(range.min) && !day.isAfter(range.max);
            return isDayInRange && day.month == monthDate.month;
          },
          dayTheme: theme?.dayTheme
        ),
      ),
    );

  @override
  double itemHeight(double itemWidth) =>
    _monthLayout.calculateHeight(itemWidth);
}
