import 'package:flutter/material.dart';

/// Layout'а календаря
abstract class ACCalendarLayout {
  const ACCalendarLayout();

  /// Физика прокрутки
  ScrollPhysics get physics;

  /// Направление прокрутки (если null, используется Axis.vertical)
  Axis get scrollDirection;
}

/// Layout для постраничной горизонтальной прокрутки
class ACCalendarPagesLayout extends ACCalendarLayout {
  const ACCalendarPagesLayout();

  @override
  ScrollPhysics get physics => const PageScrollPhysics();

  @override
  Axis get scrollDirection => Axis.horizontal;
}

/// Layout для вертикальной прокрутки
class ACCalendarVerticalLayout extends ACCalendarLayout {
  const ACCalendarVerticalLayout();

  @override
  ScrollPhysics get physics => const BouncingScrollPhysics();

  @override
  Axis get scrollDirection => Axis.vertical;
}
