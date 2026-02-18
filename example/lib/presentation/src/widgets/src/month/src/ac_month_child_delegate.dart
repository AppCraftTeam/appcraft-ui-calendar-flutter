import 'package:flutter/material.dart';

import '../../../../../presentation.dart';
// TODO: Добавить комментарии
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
abstract class ACDaysMonthChildDelegate extends ACMonthChildDelegate {
  const ACDaysMonthChildDelegate({
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
/// Содержит логику построения дней месяца с учетом доступного диапазона и темы.
/// Логика выбора, цветов и подписки на контроллер вынесена в [ACDayWidget].
class ACDefaultDaysMonthChildDelegate extends ACDaysMonthChildDelegate {
  ACDefaultDaysMonthChildDelegate({
    required super.days,
    this.dayTheme,
    this.onShouldSelect
  });

  /// Тема календаря
  final ACDayThemeData? dayTheme;

  final bool Function(DateTime day)? onShouldSelect;

  @override
  Widget buildDay(BuildContext context, DateTime day) =>
    ACDayWidget(
      dayDate: day,
      shouldSelect: onShouldSelect?.call(day),
      theme: dayTheme
    );
}

class ACCustomDaysMonthChildDelegate extends ACDaysMonthChildDelegate {
  ACCustomDaysMonthChildDelegate({
    required super.days,
    required this.dayBuilder
  });

  final Widget Function(BuildContext context, DateTime day) dayBuilder;

  @override
  Widget buildDay(BuildContext context, DateTime day) =>
    dayBuilder(context, day);
}
