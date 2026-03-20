import 'package:flutter/material.dart';

import '../domain/ac_date_range.dart';
import '../select_controller/ac_calendar_select_controller.dart';
import '../theme/ac_calendar_theme_data.dart';
import 'ac_calendar_scope.dart';
import 'ac_raw_pages_calendar_widget.dart';
import 'ac_scroll_view_controller.dart';
import 'ac_scroll_view_data_source.dart';

/// Карточка с календарём, построенная на основе [ACPagesCalendarWidget].
///
/// Отображает [ACPagesCalendarWidget] внутри декорированного контейнера.
/// При необходимости можно переопределить оформление карточки через [decoration],
/// либо точечно задать [backgroundColor] и [borderRadius].
class ACPagesCalendarCard extends StatelessWidget {
  /// Создаёт карточку с постраничным календарём.
  const ACPagesCalendarCard({
    required this.range,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.padding,
    this.decoration,
    this.borderRadius,
    this.backgroundColor,
    super.key,
  });

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Локаль для форматирования дат (например, `'ru'`, `'en'`).
  final String? locale;

  /// Тема оформления календаря.
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  final ACCalendarSelectController? selectController;

  /// Месяц, отображаемый при первом открытии.
  final DateTime? initialMonth;

  /// Отступ между элементами календаря (заголовок, строка недели, сетка дат).
  final double? spacing;

  /// Виджет, отображаемый под сеткой дат (например, ввод времени).
  final PreferredSizeWidget? timeWidget;

  /// Внешний контроллер прокрутки между месяцами.
  ///
  /// Если передан, используется вместо создаваемого по умолчанию.
  /// Вызывающий код несёт ответственность за [ACScrollViewController.dispose].
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Внешний источник данных для прокрутки между месяцами.
  ///
  /// Если передан, используется вместо создаваемого по умолчанию.
  /// Вызывающий код несёт ответственность за [ACScrollViewDataSource.dispose].
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Внутренние отступы карточки.
  ///
  /// Если не указаны, используется `EdgeInsets.all(16)`.
  final EdgeInsetsGeometry? padding;

  /// Декорация контейнера карточки.
  ///
  /// Если передана, имеет приоритет над [backgroundColor] и [borderRadius].
  final BoxDecoration? decoration;

  /// Скругление углов карточки.
  ///
  /// Игнорируется, если задан [decoration].
  /// По умолчанию `BorderRadius.all(Radius.circular(16))`.
  final BorderRadius? borderRadius;

  /// Цвет фона карточки.
  ///
  /// Игнорируется, если задан [decoration].
  /// По умолчанию `Colors.white`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = decoration ??
        BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius:
              borderRadius ?? const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, 4),
            ),
          ],
        );

    return Container(
      decoration: effectiveDecoration,
      padding: padding ?? const EdgeInsets.all(16),
      child: ACCalendarScope(
        dateRange: range,
        selectController: selectController,
        child: ACRawPagesCalendarWidget(
          range: range,
          locale: locale,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          scrollViewDataSource: scrollViewDataSource,
        ),
      ),
    );
  }
}
