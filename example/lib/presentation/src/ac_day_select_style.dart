import 'package:flutter/material.dart';

import 'theme/theme.dart';
// TODO: Refactroing
abstract class ACDaySelectStyle {
  const ACDaySelectStyle();

  Color backgroudColor(
    BuildContext context,
    [ ACCalendarThemeData? theme ]
  );
}

class ACDayDefaultSelectStyle implements ACDaySelectStyle {
  const ACDayDefaultSelectStyle();

  @override
  Color backgroudColor(
    BuildContext context,
    [ ACCalendarThemeData? theme ]
  ) => (theme ?? ACCalendarTheme.of(context)).accentColor;
}

class ACDayMiddleSelectStyle implements ACDaySelectStyle {
  const ACDayMiddleSelectStyle();

  @override
  Color backgroudColor(
    BuildContext context,
    [ ACCalendarThemeData? theme ]
  ) => (theme ?? ACCalendarTheme.of(context)).dayTheme.middleSelectedBackgroudColor;
}