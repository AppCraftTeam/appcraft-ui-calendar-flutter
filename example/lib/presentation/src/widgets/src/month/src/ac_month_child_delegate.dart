import 'package:flutter/material.dart';

import '../../../../../../../domain/src/ac_date_range.dart';
import '../../../../../presentation.dart';

/// Источник данных для месячного представления календаря.
///
/// Определяет интерфейс для построения элементов календаря.
abstract class ACMonthChildDelegate {
  const ACMonthChildDelegate();

  /// Количество элементов для отображения
  int get itemCount;

  /// Построение виджета для элемента по индексу
  Widget buildItem(BuildContext context, int index);
}

/// Источник данных с логикой создания дней месяца.
///
/// Реализует создание списка дней месяца и делегирует построение виджета для конкретного дня.
abstract class ACMonthDaysChildDelegate extends ACMonthChildDelegate {
  const ACMonthDaysChildDelegate({
    required List<DateTime> days
  }) :
    _days = days;

  /// Список дней месяца
  final List<DateTime> _days;

  @override
  int get itemCount => _days.length;

  @override
  Widget buildItem(BuildContext context, int index) =>
    buildDay(context, _days[index]);

  /// Построение виджета для конкретного дня
  Widget buildDay(BuildContext context, DateTime day);
}

/// Реализация по умолчанию источника данных для месячного представления календаря.
///
/// Содержит всю логику построения дней месяца с учетом выбора, диапазона и темы.
class DefaultMonthChildDelegate extends ACMonthDaysChildDelegate {
  DefaultMonthChildDelegate({
    required super.days,
    required this.monthDate,
    required this.range,
    this.onSelectStateForDay,
    this.onSelectDay,
    this.dayTheme,
  });

  /// Дата месяца для отображения
  final DateTime monthDate;

  /// Диапазон доступных дат для выбора
  final ACDateRange range;

  /// Функция определения состояния выбора для конкретного дня
  final ACDaySelectState? Function(DateTime day)? onSelectStateForDay;

  /// Коллбэк при выборе дня
  final void Function(DateTime day)? onSelectDay;

  /// Тема календаря
  final ACDayThemeData? dayTheme;

  @override
  Widget buildDay(BuildContext context, DateTime day) =>
    ACDayWidget(
      dayDate: day,
      theme: dayTheme,
      backgroundColor: getBackgroundColor(context, day),
      textColor: getTextColor(context, day),
      textStyle: getTextStyle(context, day),
      onTap: shouldSelectDay(day) ?
        () => onSelectDay?.call(day) :
        null
    );

  /// Определяет, должен ли день быть доступен для выбора
  bool shouldSelectDay(DateTime day) {
    final isDayInRange = !day.isBefore(range.min) && !day.isAfter(range.max);
    return isDayInRange && day.month == monthDate.month;
  }

  /// Получает разрешенную тему календаря из контекста
  ACDayThemeData getResolvedDayTheme(BuildContext context) =>
    dayTheme ?? ACCalendarTheme.of(context).dayTheme;

  /// Получает цвет фона для дня в зависимости от его состояния выбора
  Color? getBackgroundColor(BuildContext context, DateTime day) {
    final theme = getResolvedDayTheme(context);

    final selectState = shouldSelectDay(day) ?
      onSelectStateForDay?.call(day) :
      null;

    return switch (selectState) {
      null => null,
      ACDaySelectState.single => theme.selectedBackgroundColor,
      ACDaySelectState.multi => theme.selectedBackgroundColor,
      ACDaySelectState.startOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.endOfRange => theme.selectedBackgroundColor,
      ACDaySelectState.middleInRange => theme.middleSelectedBackgroudColor
    };
  }

  /// Получает цвет текста для дня
  Color getTextColor(BuildContext context, DateTime day) {
    final theme = getResolvedDayTheme(context);

    return shouldSelectDay(day) ?
      theme.textColor :
      theme.inactiveTextColor;
  }

  /// Получает стиль текста для дня
  TextStyle getTextStyle(BuildContext context, DateTime day) {
    final theme = getResolvedDayTheme(context);

    final now = DateTime.now();
    final isToday = day.year == now.year &&
      day.month == now.month &&
      day.day == now.day;

    return isToday ?
      theme.todayTextStyle :
      theme.textStyle;
  }
}
