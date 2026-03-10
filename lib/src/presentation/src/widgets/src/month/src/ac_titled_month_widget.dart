import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../presentation.dart';

/// Виджет месяца с заголовком названия месяца в правом верхнем углу.
///
/// Отображает [ACMonthWidget] с текстовым заголовком (название месяца)
/// выровненным по правому краю сверху.
class ACTitledMonthWidget extends StatelessWidget {
  const ACTitledMonthWidget({
    required this.layout,
    required this.days,
    required this.monthDate,
    this.locale,
    this.theme,
    super.key,
  });

  /// Фиксированная высота заголовка с названием месяца.
  static const double headerHeight = 24;

  /// Отступ между заголовком и сеткой месяца.
  static const double spacing = 12;

  /// Компоновка (layout) месяца, определяющая расположение элементов в сетке.
  final ACMonthLayout layout;

  /// Список дней для отображения в сетке месяца.
  final List<DateTime> days;

  /// Первый день отображаемого месяца.
  final DateTime monthDate;

  /// Локаль для форматирования названия месяца.
  ///
  /// Если не указана, берётся из [Localizations].
  final String? locale;

  /// Тема заголовка. Если не задана, берётся из [ACCalendarTheme].
  final ACTitledMonthThemeData? theme;

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).titledMonthTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: spacing,
      children: [
        SizedBox(
          height: headerHeight,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ACDateFormat.month(locale)
                  .format(monthDate)
                  .toUpperCaseFirstLetter(),
              style: theme.titleTextStyle.copyWith(color: theme.titleColor),
            ),
          ),
        ),
        Expanded(
          child: ACMonthWidget(
            layout: layout,
            days: days,
            monthDate: monthDate,
          ),
        ),
      ],
    );
  }
}
