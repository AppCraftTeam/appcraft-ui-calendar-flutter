import 'package:flutter/material.dart';

import '../../../../domain/domain.dart';
import '../../../presentation.dart';

class ACCalendarHorizontalSheet extends StatelessWidget {
  const ACCalendarHorizontalSheet({
    required this.range,
    this.weekStart,
    this.locale,
    this.theme,
    this.selectController,
    super.key,
  });

  final ACDateRange range;
  final int? weekStart;
  final String? locale;
  final ACCalendarThemeData? theme;
  final ACCalendarSelectController? selectController;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {
        
      },
      builder: (context) => Container(
        // TODO: Calculate height
        height: 410,
        decoration: BoxDecoration(
          // TODO: Add to theme
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(16)
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16
        ),
        child: ACCalendarHorizontalWidget(
          range: range,
          weekStart: weekStart,
          locale: locale,
          theme: theme,
          selectController: selectController,
        ),
      )
    );
  }
}

class ACBottomSheet extends StatelessWidget {
  const ACBottomSheet({
    required this.child,
    this.title,
    this.height,
    this.showDragHandle = true,
    this.showCloseButton = false,
    this.backgroundColor,
    this.borderRadius = 16.0,
    super.key,
  });

  final Widget child;
  final String? title;
  final double? height;
  final bool showDragHandle;
  final bool showCloseButton;
  final Color? backgroundColor;
  final double borderRadius;

  /// Показывает BottomSheet с возможностью возврата результата
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double? height,
    bool showDragHandle = true,
    bool showCloseButton = false,
    Color? backgroundColor,
    double borderRadius = 16.0,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => ACBottomSheet(
        title: title,
        height: height,
        showDragHandle: showDragHandle,
        showCloseButton: showCloseButton,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    
    final effectiveHeight = height ?? screenHeight * 0.5;
    final effectiveBackgroundColor = backgroundColor ?? theme.dialogBackgroundColor;

    return Container(
      height: effectiveHeight + bottomPadding,
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null || showCloseButton)
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: showDragHandle ? 8 : 16,
                bottom: 16,
              ),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (showCloseButton)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}