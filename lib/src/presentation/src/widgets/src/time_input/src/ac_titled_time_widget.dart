import 'package:flutter/material.dart';

import '../../../../../../localization/src/ac_default_localization_manager.dart';
import '../../../../../../utils/src/accessibility_utils.dart';
import '../../../../ac_calendar_scope.dart';
import '../../../../theme/src/ac_calendar_theme_data.dart';
import '../../../../theme/src/ac_titled_time_theme_data.dart';
import 'ac_time_input_controller.dart';
import 'ac_time_input_widget.dart';
import 'ac_time_range_input_controller.dart';
import 'ac_time_range_input_widget.dart';

/// Виджет с заголовком и полем ввода времени.
///
/// Отображает строку: заголовок слева, поле ввода времени справа.
/// Имеет два именованных конструктора:
/// - [ACTitledTimeWidget.single] — для одиночного ввода времени;
/// - [ACTitledTimeWidget.range] — для ввода диапазона времени.
///
/// Реализует [PreferredSizeWidget] с высотой [preferredHeight].
class ACTitledTimeWidget extends StatelessWidget
    implements PreferredSizeWidget {
  /// Создаёт виджет с одиночным полем ввода времени.
  ACTitledTimeWidget.single({
    this.title,
    ACTimeInputController? controller,
    this.theme,
    this.preferredHeight = 34,
    this.textScaler = TextScaler.noScaling,
    super.key,
  }) : child = IntrinsicWidth(
          child: ACTimeInputWidget(
            controller: controller,
          ),
        );

  /// Создаёт виджет с полем ввода диапазона времени.
  ACTitledTimeWidget.range({
    this.title,
    ACTimeRangeInputController? controller,
    this.theme,
    this.preferredHeight = 34,
    this.textScaler = TextScaler.noScaling,
    super.key,
  }) : child = IntrinsicWidth(
          child: ACTimeRangeInputWidget(
            controller: controller,
          ),
        );

  /// Заголовок. Если `null`, отображается `'Время'`.
  final String? title;

  /// Дочерний виджет ввода времени, обёрнутый в [SizedBox].
  final Widget child;

  /// Тема оформления. Если не задана, берётся из [ACCalendarThemeData].
  final ACTitledTimeThemeData? theme;

  /// Предпочтительная высота виджета.
  final double preferredHeight;

  /// Масштабирование текста, влияющее на высоту виджета.
  ///
  /// По умолчанию [TextScaler.noScaling] — высота не масштабируется.
  final TextScaler textScaler;

  @override
  Size get preferredSize => Size.fromHeight(textScaler.scale(preferredHeight));

  @override
  Widget build(BuildContext context) {
    final theme =
        this.theme ?? ACCalendarThemeExtension.of(context).titledTimeTheme;
    final locale = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    final effectiveTitle = title ??
        (ACCalendarScope.maybeOf(context)?.localization(locale) ??
                const ACDefaultLocalizationManager().localization(locale))
            .time;

    return SizedBox(
      height: textScaler.scale(preferredHeight),
      child: Row(
        children: [
          Expanded(
            child: Text(
              effectiveTitle,
              style: applyBoldText(
                theme.titleTextStyle.copyWith(color: theme.titleColor),
                context,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
