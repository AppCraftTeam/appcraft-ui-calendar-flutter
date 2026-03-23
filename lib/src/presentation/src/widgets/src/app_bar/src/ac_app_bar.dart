import 'package:flutter/material.dart';

/// Обёртка над стандартным [AppBar] с предустановленными значениями
/// по умолчанию для единообразного оформления навигационной панели
/// в приложении.
///
/// Все параметры являются опциональными. Для каждого null-свойства
/// подставляется дефолтное значение в методе [build].
class ACAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Создаёт [ACAppBar] с опциональными параметрами.
  const ACAppBar({
    super.key,
    this.title,
    this.actions,
    this.backgroundColor,
    this.surfaceTintColor,
    this.titleTextStyle,
    this.centerTitle,
    this.automaticallyImplyLeading,
    this.scrolledUnderElevation,
  });

  /// Виджет заголовка, отображаемый в центре или слева панели.
  final Widget? title;

  /// Список виджетов-действий, отображаемых справа от заголовка.
  final List<Widget>? actions;

  /// Цвет фона панели.
  ///
  /// По умолчанию используется [ThemeData.scaffoldBackgroundColor].
  final Color? backgroundColor;

  /// Цвет оттенка поверхности при прокрутке.
  ///
  /// По умолчанию — [Colors.transparent].
  final Color? surfaceTintColor;

  /// Стиль текста заголовка.
  ///
  /// По умолчанию — размер 17, полужирный, чёрный цвет.
  final TextStyle? titleTextStyle;

  /// Определяет, должен ли заголовок быть по центру.
  ///
  /// По умолчанию — `false`.
  final bool? centerTitle;

  /// Определяет, нужно ли автоматически добавлять кнопку «Назад».
  ///
  /// По умолчанию — `false`.
  final bool? automaticallyImplyLeading;

  /// Высота тени при прокрутке контента под панелью.
  ///
  /// По умолчанию — `0`.
  final double? scrolledUnderElevation;

  static const _defaultTitleTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: Color(0xFF000000),
  );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? false,
      centerTitle: centerTitle ?? false,
      scrolledUnderElevation: scrolledUnderElevation ?? 0,
      surfaceTintColor: surfaceTintColor ?? Colors.transparent,
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      titleTextStyle: titleTextStyle ?? _defaultTitleTextStyle,
      title: title,
      actions: actions,
    );
  }
}
