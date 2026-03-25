import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
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
    this.titleColor,
    this.titleTextStyle,
    this.backgroundColor,
    super.key,
  });

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

  /// Цвет текста года в [AppBar].
  final Color? titleColor;

  /// Стиль текста года в [AppBar].
  ///
  /// Если не указан, используется `FontWeight.w700, fontSize: 22`.
  final TextStyle? titleTextStyle;

  /// Цвет фона [Scaffold] и [AppBar].
  ///
  /// Если не указан, используется цвет из темы.
  final Color? backgroundColor;

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
    final titleStyle = (widget.titleTextStyle ??
            const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ))
        .copyWith(color: widget.titleColor);

    final backgroundColor = widget.backgroundColor ??
        ACCalendarThemeExtension.of(context).backgroundColor ??
        Theme.of(context).colorScheme.surface;

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
            timeWidgetPadding: widget.timeWidgetPadding ??
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ),
      ),
    );
  }
}
