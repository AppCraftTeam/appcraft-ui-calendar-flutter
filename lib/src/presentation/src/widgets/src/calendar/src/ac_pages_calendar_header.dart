import 'package:flutter/material.dart';

import '../../../../../../domain/src/ac_date_format.dart';
import '../../../../../../utils/src/ac_string_ext.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_pages_calendar_header_theme_data.dart';

/// Заголовок постраничного календаря с навигацией по месяцам.
///
/// Отображает название текущего месяца и года, кнопки навигации
/// вперёд/назад и иконку раскрытия выбора месяца.
class ACPagesCalendarHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// Создаёт заголовок постраничного календаря.
  const ACPagesCalendarHeader(
      {required this.monthDate,
      this.monthPickerShow = false,
      this.locale,
      this.theme,
      this.onPrevious,
      this.onNext,
      this.onMonthTap,
      this.arrowRotateDuration,
      super.key});

  /// Дата, определяющая отображаемый месяц и год.
  final DateTime monthDate;

  /// Показывает ли виджет состояние открытого month picker.
  /// При `true` скрывает стрелки навигации и поворачивает иконку-дропдаун.
  final bool monthPickerShow;

  /// Локаль для форматирования месяца и года.
  /// Если не задана, берётся из [Localizations].
  final String? locale;

  /// Тема заголовка. Если не задана, берётся из [ACCalendarThemeData].
  final ACPagesCalendarHeaderThemeData? theme;

  /// Вызывается при нажатии на кнопку "следующий месяц".
  final VoidCallback? onNext;

  /// Вызывается при нажатии на кнопку "предыдущий месяц".
  final VoidCallback? onPrevious;

  /// Длительность анимации поворота иконки-дропдауна.
  final Duration? arrowRotateDuration;

  /// Вызывается при нажатии на строку с названием месяца.
  final void Function()? onMonthTap;

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ??
        ACCalendarThemeExtension.of(context).pagesCalendarHeaderTheme;
    final locale =
        this.locale ?? Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final arrowRotateDuration =
        this.arrowRotateDuration ?? const Duration(milliseconds: 300);

    Widget navigateArrowButton(IconData icon, {VoidCallback? onPressed}) =>
        SizedBox.square(
          dimension: 24,
          child: IconButton(
              onPressed: onPressed,
              icon: Icon(icon),
              iconSize: 20,
              color: theme.arrowColor,
              padding: const EdgeInsets.all(2)),
        );

    return SizedBox(
      height: preferredSize.height,
      child: Row(
        children: [
          GestureDetector(
            onTap: onMonthTap,
            child: Row(
              children: [
                Text(
                    ACDateFormat.monthYear(locale)
                        .format(monthDate)
                        .toUpperCaseFirstLetter(),
                    style: theme.titleTextStyle.copyWith(
                      color: theme.monthTextColor,
                    )),
                AnimatedRotation(
                  turns: monthPickerShow ? -.25 : 0,
                  duration: arrowRotateDuration,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 24,
                    color: theme.monthTextColor,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          if (!monthPickerShow) ...[
            navigateArrowButton(Icons.arrow_back_ios_rounded,
                onPressed: onPrevious),
            const SizedBox(width: 12),
            navigateArrowButton(Icons.arrow_forward_ios_rounded,
                onPressed: onNext)
          ]
        ],
      ),
    );
  }
}
