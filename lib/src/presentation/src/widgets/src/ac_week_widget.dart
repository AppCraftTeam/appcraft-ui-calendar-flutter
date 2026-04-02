import 'package:flutter/material.dart';

import '../../../../data/src/ac_calendar_repository.dart';
import '../../../../data/src/ac_default_calendar_repository.dart';
import '../../../../domain/src/ac_date_format.dart';
import '../../../../utils/src/accessibility_utils.dart';
import '../../theme/src/ac_calendar_theme_data.dart';
import '../../theme/src/ac_week_theme_data.dart';

/// Виджет строки дней недели (Пн, Вт, ..., Вс).
///
/// Отображает сокращённые названия дней недели в порядке,
/// определяемом [repository].
class ACWeekWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Создаёт виджет строки дней недели.
  const ACWeekWidget({
    this.repository,
    this.locale,
    this.theme,
    this.textScaler = TextScaler.noScaling,
    super.key,
  });

  /// Репозиторий для вычислений календаря.
  ///
  /// Если не указан, используется [ACDefaultCalendarRepository].
  final ACCalendarRepository? repository;

  /// Локаль для форматирования названий дней недели.
  /// Если не задана, берётся из [Localizations].
  final String? locale;

  /// Тема строки дней недели. Если не задана, берётся из [ACCalendarThemeData].
  final ACWeekThemeData? theme;

  /// Масштабирование текста, влияющее на высоту виджета.
  ///
  /// По умолчанию [TextScaler.noScaling] — высота не масштабируется.
  final TextScaler textScaler;

  @override
  Size get preferredSize => Size.fromHeight(textScaler.scale(24));

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarThemeExtension.of(context).weekTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();

    final repository = this.repository ?? const ACDefaultCalendarRepository();

    final days = repository.getWeekDays();

    final weekTextStyle = applyBoldText(
      theme.textStyle.copyWith(color: theme.textColor),
      context,
    );

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        spacing: 6,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (final day in days)
            Text(
              ACDateFormat.weekday(locale).format(day).toUpperCase(),
              style: weekTextStyle,
            ),
        ],
      ),
    );
  }
}
