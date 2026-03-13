import 'package:flutter/material.dart';

/// Единая точка вызова `showModalBottomSheet` с дефолтными параметрами
/// библиотеки.
///
/// Для отображения bottom sheet используйте [ACBottomSheet.show].
class ACBottomSheet {
  ACBottomSheet._();

  static const _defaultBorderRadius = BorderRadius.vertical(
    top: Radius.circular(16),
  );

  /// Открывает модальный bottom sheet с дефолтными параметрами библиотеки.
  ///
  /// Все параметры можно переопределить через именованные аргументы.
  /// Возвращает `Future<T?>` с результатом от `Navigator.pop(result)`.
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
        backgroundColor:
            backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
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
