import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_cache.dart';
import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../ac_week_widget.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month/src/ac_month_widget.dart';
import '../../month_picker/src/ac_month_picker.dart';
import '../../scroll_view/src/ac_scroll_view.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_pages_calendar_header.dart';

/// Календарь с постраничной навигацией по месяцам без ACCalendarScope.
///
/// Низкоуровневый виджет, не оборачивающий себя в ACCalendarScope.
/// Используется внутри ACPagesCalendarWidget и ACPagesCalendarSheet.
class ACRawPagesCalendarWidget extends StatefulWidget {
  /// Создаёт календарь с постраничной навигацией.
  const ACRawPagesCalendarWidget({
    required this.range,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.repository,
    this.locale,
    this.initialMonth,
    this.spacing,
    this.theme,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayout,
    this.monthHeight,
    this.weekWidget,
    this.headerWidget,
    this.timeWidget,
    super.key,
  });

  /// Кастомный builder для виджета дня.
  ///
  /// Если задан, используется вместо стандартного `ACCalendarDayWidget`.
  final Widget Function(BuildContext context, DateTime day)? dayBuilder;

  /// Кастомный builder для виджета месяца.
  ///
  /// Если задан, используется вместо стандартного `ACMonthWidget`.
  /// При наличии `monthBuilder` параметр `dayBuilder` игнорируется.
  final Widget Function(BuildContext context, DateTime month)? monthBuilder;

  /// Фиксированная раскладка сетки месяца.
  ///
  /// Если задана, используется для всех месяцев вместо
  /// [ACDefaultMonthLayout.mainAxisCount6].
  final ACMonthLayout? monthLayout;

  /// Фиксированная высота сетки месяца.
  ///
  /// Если задана, используется вместо вычисленной высоты
  /// из `layout.calculateHeight`.
  final double? monthHeight;

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Локаль для форматирования дат (например, `'ru'`, `'en'`).
  ///
  /// Если не указана, используется системная локаль.
  final String? locale;

  /// Месяц, отображаемый при первом открытии календаря.
  ///
  /// Если не указан или выходит за пределы [range], используется
  /// текущий месяц (или ближайший допустимый).
  final DateTime? initialMonth;

  /// Отступ между элементами календаря (заголовок, строка недели, сетка дат).
  ///
  /// Если не указан, используется значение по умолчанию `12.0`.
  final double? spacing;

  /// Кастомный виджет строки дней недели.
  ///
  /// Если задан, используется вместо стандартного [ACWeekWidget].
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  /// Кастомный виджет заголовка календаря.
  ///
  /// Если задан, используется вместо стандартного [ACPagesCalendarHeader].
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? headerWidget;

  /// Данные темы оформления календаря.
  final ACCalendarThemeData? theme;

  /// Виджет, отображаемый под сеткой дат (например, ввод времени).
  ///
  /// Должен реализовывать [PreferredSizeWidget] для корректного расчёта высоты.
  final PreferredSizeWidget? timeWidget;

  /// Внешний контроллер прокрутки между месяцами.
  ///
  /// Если передан, виджет использует его вместо создания внутреннего.
  /// Вызывающий код несёт ответственность за вызов [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Внешний источник данных для [ACScrollView].
  ///
  /// Если передан, виджет использует его вместо создания внутреннего.
  /// Вызывающий код несёт ответственность за вызов [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Возвращает предпочтительную высоту виджета для заданной ширины [width].
  ///
  /// Используется для динамического расчёта высоты `ACPagesCalendarSheet`
  /// без хардкода. Учитывает заголовок, строку недели, сетку дат и опциональный
  /// [timeWidget].
  static double preferredHeight(
    double width, {
    double spacing = 12.0,
    PreferredSizeWidget? timeWidget,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    const headerHeight = 40.0;
    const weekHeight = 24.0;
    final effectiveWidth = width - padding.horizontal;
    final monthHeight =
        ACDefaultMonthLayout.mainAxisCount6.calculateHeight(effectiveWidth);

    final contentHeight = weekHeight +
        spacing +
        monthHeight +
        (timeWidget != null ? spacing + timeWidget.preferredSize.height : 0);

    return headerHeight + spacing + contentHeight + padding.vertical;
  }

  @override
  State<ACRawPagesCalendarWidget> createState() =>
      _ACRawPagesCalendarWidgetState();
}

class _ACRawPagesCalendarWidgetState extends State<ACRawPagesCalendarWidget> {
  late final ACCalendarRepository _repository =
      widget.repository ?? const ACDefaultCalendarRepository();

  /// Кэш списков дней для каждого месяца (последние 12 месяцев).
  final _daysCache = ACCache<DateTime, List<DateTime>>(12);

  ACMonthLayout get _layout =>
      widget.monthLayout ?? ACDefaultMonthLayout.mainAxisCount6;

  /// Диапазон допустимых месяцев, нормализованный к началу месяца.
  late ACDateRange _range;

  /// Текущий видимый месяц.
  late DateTime _currentMonth;

  /// Контроллер горизонтальной прокрутки между месяцами.
  late ACScrollViewController<DateTime> _scrollViewController;

  /// Источник данных для ACScrollView.
  late ACScrollViewDataSource<DateTime> _scrollViewDataSource;

  /// Флаг отображения выбора месяца вместо сетки дат.
  var _monthPickerShow = false;

  @override
  void initState() {
    super.initState();

    _range = ACDateRange(
      min: _repository.startOfMonth(widget.range.min),
      max: _repository.startOfMonth(widget.range.max),
    );

    _currentMonth = _range.clampDate(
      _repository.startOfMonth(widget.initialMonth ?? DateTime.now()),
    );

    _scrollViewController =
        widget.scrollViewController ?? ACScrollViewController<DateTime>();

    _scrollViewDataSource = widget.scrollViewDataSource ??
        ACDefaultScrollViewDataSource<DateTime>(
          initialItem: _currentMonth,
          onBefore: (month) {
            final prev = _repository.addMonths(month, -1);
            return prev.isBefore(_range.min) ? null : prev;
          },
          onAfter: (month) {
            final next = _repository.addMonths(month, 1);
            return next.isAfter(_range.max) ? null : next;
          },
        );
  }

  @override
  void didUpdateWidget(ACRawPagesCalendarWidget oldWidget) {
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
      _scrollViewDataSource = widget.scrollViewDataSource ??
          ACDefaultScrollViewDataSource<DateTime>(
            initialItem: _currentMonth,
            onBefore: (month) {
              final prev = _repository.addMonths(month, -1);
              return prev.isBefore(_range.min) ? null : prev;
            },
            onAfter: (month) {
              final next = _repository.addMonths(month, 1);
              return next.isAfter(_range.max) ? null : next;
            },
          );
    }

    if (widget.range.min != oldWidget.range.min ||
        widget.range.max != oldWidget.range.max) {
      _range = ACDateRange(
        min: _repository.startOfMonth(widget.range.min),
        max: _repository.startOfMonth(widget.range.max),
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

  /// Возвращает список дат для отображения в сетке [monthDate].
  ///
  /// Результат кэшируется, чтобы избежать повторных вычислений при перестройке.
  List<DateTime> _getDays(DateTime monthDate) => _daysCache.putIfAbsent(
        monthDate,
        () => _repository.getMonthDays(monthDate),
      );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final spacing = widget.spacing ?? 12.0;
          final monthWidth = constraints.maxWidth;
          final monthHeight =
              widget.monthHeight ?? _layout.calculateHeight(monthWidth);

          final weekWidget = widget.weekWidget ??
              ACWeekWidget(
                repository: widget.repository,
                locale: widget.locale,
                theme: widget.theme?.weekTheme,
              );

          final headerWidget = widget.headerWidget ??
              ACPagesCalendarHeader(
                monthDate: _currentMonth,
                locale: widget.locale,
                monthPickerShow: _monthPickerShow,
                theme: widget.theme?.pagesCalendarHeaderTheme,
                onPrevious: _scrollViewDataSource.shouldBefore
                    ? _scrollViewController.animateToBeforeItem
                    : null,
                onNext: _scrollViewDataSource.shouldAfter
                    ? _scrollViewController.animateToAfterItem
                    : null,
                onMonthTap: () => setState(() {
                  _monthPickerShow = !_monthPickerShow;
                }),
              );

          Widget scrollView() => SizedBox(
                width: monthWidth,
                height: monthHeight,
                child: ACScrollView<DateTime>(
                  physics: const PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: _scrollViewController,
                  dataSource: _scrollViewDataSource,
                  itemExtentBuilder: (_) => monthWidth,
                  onVisibleItemChanged: (monthDate) => setState(() {
                    _currentMonth = monthDate;
                  }),
                  itemBuilder: (context, monthDate) => SizedBox(
                    width: monthWidth,
                    height: monthHeight,
                    child: RepaintBoundary(
                      child: widget.monthBuilder?.call(context, monthDate) ??
                          ACMonthWidget(
                            dayTheme: widget.theme?.dayTheme,
                            layout: _layout,
                            days: _getDays(monthDate),
                            monthDate: monthDate,
                            dayBuilder: widget.dayBuilder,
                          ),
                    ),
                  ),
                ),
              );

          Widget monthPicker() => ACMonthPicker(
                repository: widget.repository,
                range: _range,
                onDateChanged: _scrollViewController.jumpToItem,
                initialDate: _currentMonth,
                locale: widget.locale,
                theme: widget.theme,
              );

          final timeWidget = widget.timeWidget;

          final contentHeight = [
            weekWidget.preferredSize.height,
            spacing,
            monthHeight,
            if (timeWidget != null) ...[
              spacing,
              timeWidget.preferredSize.height,
            ],
          ].fold<double>(0, (sum, v) => sum + v);

          return Column(
            spacing: spacing,
            children: [
              headerWidget,
              SizedBox(
                height: contentHeight,
                child: _monthPickerShow
                    ? monthPicker()
                    : Column(
                        spacing: spacing,
                        children: [
                          weekWidget,
                          scrollView(),
                          if (timeWidget != null) timeWidget
                        ],
                      ),
              )
            ],
          );
        },
      );
}
