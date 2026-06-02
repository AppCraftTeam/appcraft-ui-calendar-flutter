import 'package:flutter/material.dart';

/// A wrapper around the standard [AppBar] with preset default values
/// for a consistent navigation bar appearance across the app.
///
/// All parameters are optional. For each null property,
/// a default value is substituted in the [build] method.
class ACAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates an [ACAppBar] with optional parameters.
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

  /// Title widget displayed in the center or on the left of the bar.
  final Widget? title;

  /// List of action widgets displayed to the right of the title.
  final List<Widget>? actions;

  /// Background color of the bar.
  ///
  /// Defaults to [ThemeData.scaffoldBackgroundColor].
  final Color? backgroundColor;

  /// Surface tint color on scroll.
  ///
  /// Defaults to [Colors.transparent].
  final Color? surfaceTintColor;

  /// Title text style.
  ///
  /// Defaults to size 17, semi-bold, black color.
  final TextStyle? titleTextStyle;

  /// Determines whether the title should be centered.
  ///
  /// Defaults to `false`.
  final bool? centerTitle;

  /// Determines whether the "Back" button should be added automatically.
  ///
  /// Defaults to `false`.
  final bool? automaticallyImplyLeading;

  /// Shadow elevation when content is scrolled under the bar.
  ///
  /// Defaults to `0`.
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
