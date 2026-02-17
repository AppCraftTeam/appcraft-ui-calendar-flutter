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
class PagesCalendarLayout extends ACCalendarLayout {
  const PagesCalendarLayout();

  @override
  ScrollPhysics get physics => const PageScrollPhysics();

  @override
  Axis get scrollDirection => Axis.horizontal;
}

/// Layout для вертикальной прокрутки
class VerticalCalendarLayout extends ACCalendarLayout {
  const VerticalCalendarLayout();

  @override
  ScrollPhysics get physics => const BouncingScrollPhysics();

  @override
  Axis get scrollDirection => Axis.vertical;
}
