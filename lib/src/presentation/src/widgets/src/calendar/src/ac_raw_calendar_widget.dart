import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_month_cache.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_week_widget.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month/src/ac_titled_month_widget.dart';
import '../../scroll_view/src/ac_scroll_view.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';

/// Календарь с вертикальной прокруткой по месяцам без ACCalendarScope.
///
/// Низкоуровневый виджет, не оборачивающий себя в ACCalendarScope.
/// Используется внутри ACCalendarWidget и ACCalendarScreen.
class ACRawCalendarWidget extends StatefulWidget {
  /// Создаёт календарь с вертикальной прокруткой.
  const ACRawCalendarWidget({
    required this.range,
    this.repository,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.theme,
    this.weekPadding,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayoutBuilder,
    this.monthHeightBuilder,
    this.timeWidgetPadding,
    super.key,
  });

  /// Кастомный builder для виджета дня.
  ///
  /// Если задан, используется вместо стандартного `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Кастомный builder для виджета месяца.
  ///
  /// Если задан, используется вместо стандартного `ACTitledMonthWidget`.
  /// При наличии `monthBuilder` параметр `dayBuilder` игнорируется.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Кастомный builder для раскладки месяца.
  ///
  /// Вызывается для каждого месяца, позволяя задать раскладку индивидуально.
  /// Если не задан, раскладка рассчитывается автоматически.
  final ACMonthLayout Function(BuildContext context, DateTime month)?
      monthLayoutBuilder;

  /// Кастомный builder для высоты месяца.
  ///
  /// Вызывается для каждого месяца, позволяя задать высоту индивидуально.
  /// Если не задан, высота рассчитывается автоматически.
  final double Function(BuildContext context, DateTime month)?
      monthHeightBuilder;

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Контроллер прокрутки.
  ///
  /// Если не указан, создаётся автоматически внутри виджета.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Источник данных для прокрутки по месяцам.
  ///
  /// Если не указан, создаётся автоматически на основе [range].
  /// Владелец переданного источника отвечает за вызов [dispose()].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Дата, к которой будет выполнена прокрутка при первом открытии.
  ///
  /// Если не указана или выходит за пределы [range], используется текущая дата
  /// (или ближайший допустимый месяц).
  final DateTime? initialDate;

  /// Вызывается при смене видимого месяца во время прокрутки.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Виджет, отображаемый под лентой месяцев (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Данные темы оформления календаря.
  final ACCalendarThemeData? theme;

  /// Отступы вокруг ленты месяцев.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Отступы вокруг [ACWeekWidget].
  final EdgeInsetsGeometry? weekPadding;

  /// Отступы вокруг [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  @override
  State<ACRawCalendarWidget> createState() => _ACRawCalendarWidgetState();
}

class _ACRawCalendarWidgetState extends State<ACRawCalendarWidget> {
  late final ACCalendarRepository _calendarRepository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Кэш данных месяцев (до 12 месяцев).
  final _monthDataCache = ACCache<DateTime, ACCalendarMonthCache>(12);

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер вертикальной прокрутки между месяцами.
  late ACScrollViewController<DateTime> _scrollViewController;

  /// Источник данных для ACScrollView.
  late ACScrollViewDataSource<DateTime> _scrollViewDataSource;

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

    _scrollViewController =
        widget.scrollViewController ?? ACScrollViewController<DateTime>();

    _scrollViewDataSource =
        widget.scrollViewDataSource ?? _createDefaultDataSource();
  }

  /// Создаёт внутренний источник данных на основе текущего диапазона.
  ACDefaultScrollViewDataSource<DateTime> _createDefaultDataSource() =>
      ACDefaultScrollViewDataSource<DateTime>(
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

  @override
  void didUpdateWidget(ACRawCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollViewController != widget.scrollViewController) {
      if (_scrollViewController != oldWidget.scrollViewController) {
        _scrollViewController.dispose();
      }
      _scrollViewController =
          widget.scrollViewController ?? ACScrollViewController<DateTime>();
    }

    if (oldWidget.scrollViewDataSource != widget.scrollViewDataSource) {
      if (_scrollViewDataSource != oldWidget.scrollViewDataSource) {
        _scrollViewDataSource.dispose();
      }
      _scrollViewDataSource =
          widget.scrollViewDataSource ?? _createDefaultDataSource();
    }

    if (oldWidget.range.min != widget.range.min ||
        oldWidget.range.max != widget.range.max) {
      _range = ACDateRange(
        min: _calendarRepository.startOfMonth(widget.range.min),
        max: _calendarRepository.startOfMonth(widget.range.max),
      );

      _currentMonth = _range.clampDate(_currentMonth);
      _scrollViewController.jumpToItem(_currentMonth);
    }
  }

  @override
  void dispose() {
    if (_scrollViewController != widget.scrollViewController) {
      _scrollViewController.dispose();
    }
    if (_scrollViewDataSource != widget.scrollViewDataSource) {
      _scrollViewDataSource.dispose();
    }
    super.dispose();
  }

  /// Возвращает кэшированные данные месяца или вычисляет их.
  ACCalendarMonthCache _getMonthCache(DateTime monthDate) =>
      _monthDataCache.putIfAbsent(monthDate, () {
        final days = _calendarRepository.getMonthDays(monthDate);

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
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final timeWidget = widget.timeWidget;

          double itemExtentBuilder(DateTime monthDate) =>
              widget.monthHeightBuilder?.call(context, monthDate) ??
              (ACTitledMonthWidget.headerHeight +
                  ACTitledMonthWidget.spacing +
                  (widget.monthLayoutBuilder?.call(context, monthDate) ??
                          _getMonthCache(monthDate).layout)
                      .calculateHeight(constraints.maxWidth));

          Widget itemBuilder(BuildContext context, DateTime monthDate) {
            final monthData = _getMonthCache(monthDate);
            final layout =
                widget.monthLayoutBuilder?.call(context, monthDate) ??
                    monthData.layout;
            final height =
                widget.monthHeightBuilder?.call(context, monthDate) ??
                    (ACTitledMonthWidget.headerHeight +
                        ACTitledMonthWidget.spacing +
                        layout.calculateHeight(constraints.maxWidth));

            return SizedBox(
              width: constraints.maxWidth,
              height: height,
              child: RepaintBoundary(
                child: widget.monthBuilder?.call(context, monthDate) ??
                    ACTitledMonthWidget(
                      layout: layout,
                      days: monthData.days,
                      monthDate: monthDate,
                      theme: widget.theme?.titledMonthTheme,
                      dayTheme: widget.theme?.dayTheme,
                      dayBuilder: widget.dayBuilder,
                    ),
              ),
            );
          }

          final scrollView = ACScrollView<DateTime>(
              controller: _scrollViewController,
              dataSource: _scrollViewDataSource,
              spacing: 40,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              padding: widget.scrollViewPadding ?? EdgeInsets.zero,
              itemExtentBuilder: itemExtentBuilder,
              onVisibleItemChanged: (monthDate) {
                _currentMonth = monthDate;
                widget.onVisibleDateChanged?.call(monthDate);
              },
              itemBuilder: itemBuilder);

          return Column(
            children: [
              Padding(
                padding: widget.weekPadding ?? const EdgeInsets.only(bottom: 8),
                child: ACWeekWidget(
                  repository: widget.repository,
                  theme: widget.theme?.weekTheme,
                ),
              ),
              Expanded(child: scrollView),
              if (timeWidget != null)
                Padding(
                  padding:
                      widget.timeWidgetPadding ?? const EdgeInsets.only(top: 8),
                  child: timeWidget,
                ),
            ],
          );
        },
      );
}
