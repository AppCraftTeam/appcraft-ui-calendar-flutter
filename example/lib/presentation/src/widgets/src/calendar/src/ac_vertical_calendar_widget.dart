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

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер вертикальной прокрутки между месяцами.
  late final ACScrollViewController<DateTime> _scrollViewController;

  /// Источник данных для ACScrollView.
  late final ACDefaultScrollViewDataSource<DateTime> _scrollViewDataSource;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _calendarRepository.startOfMonth(widget.range.min),
      max: _calendarRepository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _calendarRepository.startOfMonth(widget.initialDate ?? DateTime.now()),
    );

    _scrollViewController = ACScrollViewController<DateTime>();
    _scrollViewDataSource = ACDefaultScrollViewDataSource<DateTime>(
      initialItem: _currentMonth,
      onBefore: (month) {
        final prev = _calendarRepository.addMonths(month, -1);
        return prev.isBefore(_range.min) ? null : prev;
      },
      onAfter: (month) {
        final next = _calendarRepository.addMonths(month, 1);
        return next.isAfter(_range.max) ? null : next;
      },
    );
  }

  @override
  void didUpdateWidget(ACVerticalCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (
      oldWidget.range.min != widget.range.min ||
      oldWidget.range.max != widget.range.max ||
      oldWidget.weekStart != widget.weekStart
    ) {
      _range = ACDateRange(
        min: _calendarRepository.startOfMonth(widget.range.min),
        max: _calendarRepository.startOfMonth(widget.range.max),
      );

      // Зажимаем текущий месяц в новый диапазон и переинициализируем данные.
      // Замыкания onBefore/onAfter ссылаются на _range через this,
      // поэтому автоматически подхватывают новое значение.
      _currentMonth = _range.clampDate(_currentMonth);
      _scrollViewController.jumpToItem(_currentMonth);
    }
  }

  @override
  void dispose() {
    _scrollViewController.dispose();
    _scrollViewDataSource.dispose();
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
        builder: (context, constraints) => ACScrollView<DateTime>(
          controller: _scrollViewController,
          dataSource: _scrollViewDataSource,
          spacing: 40,
          padding: const EdgeInsets.all(16),
          itemExtentBuilder: (monthDate) =>
            ACTitledMonthWidget.headerHeight +
            ACTitledMonthWidget.spacing +
            _getMonthCache(monthDate).layout.calculateHeight(constraints.maxWidth),
          onVisibleItemChanged: (monthDate) {
            _currentMonth = monthDate;
            widget.onVisibleDateChanged?.call(monthDate);
          },
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
        ),
      ),
    );
}
