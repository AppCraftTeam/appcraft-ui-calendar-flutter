import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../month/src/ac_month_layout.dart';
import '../../month_picker/src/ac_month_picker_sheet.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import 'ac_raw_calendar_widget.dart';

/// Экран с вертикальным календарём.
///
/// Оборачивает `ACCalendarWidget` в [Scaffold] с [AppBar],
/// в котором отображается актуальный год видимого месяца.
/// Год автоматически обновляется при прокрутке через [onVisibleDateChanged].
class ACCalendarScreen extends StatefulWidget {
  /// Создаёт экран с вертикальным календарём.
  const ACCalendarScreen({
    required this.range,
    this.theme,
    this.selectController,
    this.initialDate,
    this.onVisibleDateChanged,
    this.timeWidget,
    this.scrollViewPadding,
    this.weekPadding,
    this.timeWidgetPadding,
    this.dayBuilder,
    this.monthBuilder,
    this.monthLayoutBuilder,
    this.monthHeightBuilder,
    this.weekWidget,
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

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Тема оформления календаря.
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  final ACCalendarSelectController? selectController;

  /// Дата, к которой будет выполнена прокрутка при первом открытии.
  final DateTime? initialDate;

  /// Вызывается при смене видимого месяца во время прокрутки.
  final void Function(DateTime visibleDate)? onVisibleDateChanged;

  /// Виджет, отображаемый под лентой месяцев (например, ввод времени).
  final PreferredSizeWidget? timeWidget;

  /// Отступы вокруг ленты месяцев.
  final EdgeInsetsGeometry? scrollViewPadding;

  /// Отступы вокруг строки дней недели.
  final EdgeInsetsGeometry? weekPadding;

  /// Отступы вокруг [timeWidget].
  final EdgeInsetsGeometry? timeWidgetPadding;

  /// Кастомный виджет строки дней недели.
  ///
  /// Если задан, используется вместо стандартного `ACWeekWidget`.
  /// Должен реализовывать [PreferredSizeWidget].
  final PreferredSizeWidget? weekWidget;

  @override
  State<ACCalendarScreen> createState() => _ACCalendarScreenState();
}

class _ACCalendarScreenState extends State<ACCalendarScreen> {
  late DateTime _currentDate;

  final _scrollViewController = ACScrollViewController<DateTime>();

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate ?? DateTime.now();
  }

  void _onVisibleDateChanged(DateTime date) {
    if (_currentDate != date) {
      setState(() => _currentDate = date);
    }
    widget.onVisibleDateChanged?.call(date);
  }

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 22,
    );

    final backgroundColor = widget.theme?.backgroundColor ??
        ACCalendarThemeExtension.of(context).backgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        title: GestureDetector(
          onTap: () => ACMonthPickerSheet.show(
            context,
            range: widget.range,
            initialDate: _currentDate,
            theme: widget.theme,
            onDone: (date) {
              _onVisibleDateChanged(date);
              _scrollViewController.jumpToItem(date);
            },
          ),
          child: Text('${_currentDate.year}', style: titleStyle),
        ),
      ),
      body: SafeArea(
        child: ACCalendarScope(
          dateRange: widget.range,
          selectController: widget.selectController,
          child: ACRawCalendarWidget(
            scrollViewController: _scrollViewController,
            range: widget.range,
            theme: widget.theme,
            initialDate: widget.initialDate,
            onVisibleDateChanged: _onVisibleDateChanged,
            timeWidget: widget.timeWidget,
            scrollViewPadding: widget.scrollViewPadding ??
                const EdgeInsets.symmetric(horizontal: 16),
            weekPadding: widget.weekPadding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            dayBuilder: widget.dayBuilder,
            monthBuilder: widget.monthBuilder,
            monthLayoutBuilder: widget.monthLayoutBuilder,
            monthHeightBuilder: widget.monthHeightBuilder,
            weekWidget: widget.weekWidget,
            timeWidgetPadding: widget.timeWidgetPadding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
