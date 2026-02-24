import 'package:flutter/material.dart';

import '../../../../../../data/data.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../presentation.dart';

/// Календарь с вертикальной прокруткой по месяцам.
///
/// Отображает непрерывную ленту месяцев с возможностью вертикальной прокрутки
/// в пределах заданного диапазона [range].
class ACVerticalCalendarWidget extends StatefulWidget {
  const ACVerticalCalendarWidget({
    required this.range,
    this.weekStart,
    this.theme,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    super.key,
  });

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// День начала недели (0 — воскресенье, 1 — понедельник и т. д.).
  ///
  /// Если не указан, используется локальное значение по умолчанию.
  final int? weekStart;

  /// Тема оформления календаря.
  ///
  /// Если не указана, используется [ACLightCalendarThemeData].
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  ///
  /// Если не указан, выбор дат не поддерживается.
  final ACCalendarSelectController? selectController;

  /// Дата, к которой будет выполнена прокрутка при первом открытии.
  ///
  /// Если не указана или выходит за пределы [range], используется текущая дата
  /// (или ближайший допустимый месяц).
  final DateTime? initialDate;

  /// Вызывается при смене видимого месяца во время прокрутки.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  @override
  State<ACVerticalCalendarWidget> createState() => _ACVerticalCalendarWidgetState();
}

class _ACVerticalCalendarWidgetState extends State<ACVerticalCalendarWidget> {
  final _calendarRepository = const ACCalendarRepository();

  /// Кэш данных месяцев (до 12 месяцев).
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Месяц, с которого начинается отображение (используется при создании контроллера).
  late DateTime _initialMonth;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер вертикальной прокрутки между месяцами.
  ///
  /// Создаётся лениво в [build], пересоздаётся при изменении диапазона дат или первого дня недели.
  ACScrollViewController<DateTime>? _scrollViewController;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _calendarRepository.startOfMonth(widget.range.min),
      max: _calendarRepository.startOfMonth(widget.range.max),
    );

    _initialMonth = _range.clampDate(
      _calendarRepository.startOfMonth(widget.initialDate ?? DateTime.now()),
    );

    _currentMonth = _initialMonth;
  }

  @override
  void didUpdateWidget(ACVerticalCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Пересоздаём контроллер при изменении диапазона или первого дня недели,
    // так как эти параметры передаются в контроллер при создании и не могут
    // быть обновлены без его пересоздания.
    if (
      oldWidget.range.min != widget.range.min ||
      oldWidget.range.max != widget.range.max ||
      oldWidget.weekStart != widget.weekStart
    ) {
      _range = ACDateRange(
        min: _calendarRepository.startOfMonth(widget.range.min),
        max: _calendarRepository.startOfMonth(widget.range.max),
      );

      _scrollViewController?.dispose();
      _scrollViewController = null;

      // Зажимаем текущий месяц в новый диапазон, чтобы не оказаться
      // за его пределами после обновления.
      _currentMonth = _range.clampDate(_currentMonth);
      _initialMonth = _currentMonth;
    }
  }

  @override
  void dispose() {
    _scrollViewController?.dispose();
    super.dispose();
  }

  /// Возвращает кэшированные данные месяца или вычисляет их.
  ///
  /// Определяет список дней и подходящий [ACMonthLayout] в зависимости
  /// от количества недель в месяце.
  ACCalendarMonthCache _getMonthCache(DateTime monthDate) =>
    _monthDataCache.putIfAbsent(monthDate, () {
      final days = _calendarRepository.getMonthDays(
        monthDate,
        weekStart: widget.weekStart,
      );

      final weeksCount = (days.length / 7).toInt();
      final ACMonthLayout layout = switch (weeksCount) {
        4 => ACDefaultMonthLayout.mainAxisCount4,
        5 => ACDefaultMonthLayout.mainAxisCount5,
        6 => ACDefaultMonthLayout.mainAxisCount6,
        _ => ACDefaultMonthLayout(mainAxisCount: weeksCount),
      };

      return ACCalendarMonthCache(days: days, layout: layout);
    });

  @override
  Widget build(BuildContext context) =>
    ACCalendarScope(
      theme: widget.theme,
      dateRange: widget.range,
      selectController: widget.selectController,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Контроллер создаётся один раз и переиспользуется между перестройками.
          // Обнуляется в didUpdateWidget при изменении range или weekStart.
          _scrollViewController ??= ACDateRangeScrollViewController(
            initialMonth: _initialMonth,
            range: _range,
            onVisibleItemChanged: (monthDate) {
              _currentMonth = monthDate;
              widget.onVisibleDateChanged?.call(monthDate);
            },
            itemExtentBuilder: (monthDate) =>
              ACTitledMonthWidget.headerHeight +
              ACTitledMonthWidget.spacing +
              _getMonthCache(monthDate).layout.calculateHeight(constraints.maxWidth),
          );

          return ACScrollView<DateTime>(
            controller: _scrollViewController!,
            itemBuilder: (context, monthDate) {
              final monthData = _getMonthCache(monthDate);
              final height = ACTitledMonthWidget.headerHeight +
                ACTitledMonthWidget.spacing +
                monthData.layout.calculateHeight(constraints.maxWidth);

              return SizedBox(
                width: constraints.maxWidth,
                height: height,
                child: RepaintBoundary(
                  child: ACTitledMonthWidget(
                    layout: monthData.layout,
                    days: monthData.days,
                    monthDate: monthDate,
                  ),
                ),
              );
            },
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
          );
        },
      ),
    );
}
