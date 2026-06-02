import 'package:flutter/material.dart';

import '../../../../theme/src/ac_calendar_theme_data.dart';

/// A single entry point for calling `showModalBottomSheet` with the
/// library's default parameters.
///
/// Use [ACBottomSheet.show] to display a bottom sheet.
class ACBottomSheet {
  ACBottomSheet._();

  static const _defaultBorderRadius = BorderRadius.vertical(
    top: Radius.circular(16),
  );

  /// Opens a modal bottom sheet with the library's default parameters.
  ///
  /// All parameters can be overridden via named arguments.
  /// Returns a `Future<T?>` with the result from `Navigator.pop(result)`.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool useRootNavigator = true,
    bool useSafeArea = true,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool showDragHandle = false,
    Color? backgroundColor,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    double? elevation,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    RouteSettings? routeSettings,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        builder: builder,
        useRootNavigator: useRootNavigator,
        useSafeArea: useSafeArea,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        showDragHandle: showDragHandle,
        backgroundColor: backgroundColor ??
            ACCalendarThemeExtension.of(context).backgroundColor,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: _defaultBorderRadius,
            ),
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        constraints: constraints,
        elevation: elevation,
        transitionAnimationController: transitionAnimationController,
        anchorPoint: anchorPoint,
        routeSettings: routeSettings,
      );
}
