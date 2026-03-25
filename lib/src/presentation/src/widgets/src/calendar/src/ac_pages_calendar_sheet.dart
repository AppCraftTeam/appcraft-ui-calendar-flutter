import 'package:flutter/material.dart';

import '../../../../../../data/src/ac_calendar_repository.dart';
import '../../../../../../domain/src/ac_date_range.dart';
import '../../../../../../localization/src/ac_default_localization_manager.dart';
import '../../../../../../localization/src/ac_localization_manager.dart';
import '../../../../select_controller/ac_calendar_select_controller.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../app_bar/src/ac_app_bar.dart';
import '../../bottom_sheet/src/ac_bottom_sheet.dart';
import '../../scroll_view/src/ac_scroll_view_controller.dart';
import '../../scroll_view/src/ac_scroll_view_data_source.dart';
import 'ac_pages_calendar_widget.dart';
import 'ac_raw_pages_calendar_widget.dart';

/// Нижний лист (bottom sheet) с [ACPagesCalendarWidget].
///
/// Для отображения используйте статический метод [ACPagesCalendarSheet.show].
class ACPagesCalendarSheet extends StatelessWidget {
  /// Создаёт нижний лист с постраничным календарём.
  const ACPagesCalendarSheet({
    required this.range,
    this.repository,
    this.locale,
    this.theme,
    this.selectController,
    this.initialMonth,
    this.spacing,
    this.timeWidget,
    this.scrollViewController,
    this.scrollViewDataSource,
    this.onDone,
    this.localizationManager,
    this.padding,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  final ACCalendarRepository? repository;

  /// Допустимый диапазон дат для навигации.
  final ACDateRange range;

  /// Локаль для форматирования дат.
  final String? locale;

  /// Тема оформления календаря.
  final ACCalendarThemeData? theme;

  /// Контроллер выбора дат.
  final ACCalendarSelectController? selectController;

  /// Месяц, отображаемый при первом открытии.
  final DateTime? initialMonth;

  /// Отступ между элементами календаря.
  final double? spacing;

  /// Виджет, отображаемый под сеткой дат.
  final PreferredSizeWidget? timeWidget;

  /// Контроллер прокрутки между месяцами.
  final ACScrollViewController<DateTime>? scrollViewController;

  /// Источник данных для прокрутки между месяцами.
  final ACScrollViewDataSource<DateTime>? scrollViewDataSource;

  /// Вызывается при нажатии кнопки «Готово».
  final VoidCallback? onDone;

  /// Менеджер локализации.
  final ACLocalizationManager? localizationManager;

  /// Внутренний отступ вокруг [ACPagesCalendarWidget].
  ///
  /// Если не задан, используется `EdgeInsets.all(16)`.
  final EdgeInsets? padding;

  /// Открывает bottom sheet с [ACPagesCalendarWidget].
  static Future<void> show(
    BuildContext context, {
    required ACDateRange range,
    ACCalendarRepository? repository,
    String? locale,
    ACCalendarThemeData? theme,
    ACCalendarSelectController? selectController,
    DateTime? initialMonth,
    double? spacing,
    PreferredSizeWidget? timeWidget,
    ACScrollViewController<DateTime>? scrollViewController,
    ACScrollViewDataSource<DateTime>? scrollViewDataSource,
    VoidCallback? onDone,
    ACLocalizationManager? localizationManager,
    EdgeInsets? padding,
  }) =>
      ACBottomSheet.show(
        context,
        isScrollControlled: true,
        backgroundColor: theme?.backgroundColor,
        builder: (context) => ACPagesCalendarSheet(
          range: range,
          repository: repository,
          locale: locale,
          theme: theme,
          selectController: selectController,
          initialMonth: initialMonth,
          spacing: spacing,
          timeWidget: timeWidget,
          scrollViewController: scrollViewController,
          scrollViewDataSource: scrollViewDataSource,
          onDone: onDone,
          localizationManager: localizationManager,
          padding: padding,
        ),
      );

  void _onDone(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    final effectivePadding = padding ?? const EdgeInsets.all(16);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final localization =
        (localizationManager ?? const ACDefaultLocalizationManager())
            .localization(
      locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final calendarHeight = ACRawPagesCalendarWidget.preferredHeight(
          constraints.maxWidth,
          spacing: spacing ?? 12.0,
          timeWidget: timeWidget,
          padding: effectivePadding,
        );

        return SizedBox(
          height: kToolbarHeight + calendarHeight + bottomPadding,
          child: Scaffold(
            appBar: ACAppBar(
              title: Text(localization.calendar),
              actions: [
                TextButton(
                  onPressed: () => _onDone(context),
                  child: Text(localization.done),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: effectivePadding,
                child: ACPagesCalendarWidget(
                  range: range,
                  repository: repository,
                  locale: locale,
                  theme: theme,
                  selectController: selectController,
                  initialMonth: initialMonth,
                  spacing: spacing,
                  timeWidget: timeWidget,
                  scrollViewController: scrollViewController,
                  scrollViewDataSource: scrollViewDataSource,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
