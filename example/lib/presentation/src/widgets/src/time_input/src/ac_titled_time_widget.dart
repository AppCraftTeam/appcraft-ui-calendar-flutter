import 'package:flutter/material.dart';

import '../../../../../presentation.dart';

/// Виджет с заголовком и полем ввода времени.
///
/// Отображает строку: заголовок слева, поле ввода времени справа.
/// Имеет два именованных конструктора:
/// - [ACTitledTimeWidget.single] — для одиночного ввода времени;
/// - [ACTitledTimeWidget.range] — для ввода диапазона времени.
///
/// Реализует [PreferredSizeWidget] с высотой [preferredHeight].
class ACTitledTimeWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Создаёт виджет с одиночным полем ввода времени.
  ACTitledTimeWidget.single({
    this.title,
    ACTimeInputController? controller,
    this.theme,
    this.preferredHeight = 34,
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

  /// Тема оформления. Если не задана, берётся из [ACCalendarTheme].
  final ACTitledTimeThemeData? theme;

  /// Предпочтительная высота виджета.
  final double preferredHeight;

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? ACCalendarTheme.of(context).titledTimeTheme;

    return SizedBox(
      height: preferredHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              // TODO: добавить локализацию
              title ?? 'Время',
              style: theme.titleTextStyle.copyWith(
                color: theme.titleColor,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
