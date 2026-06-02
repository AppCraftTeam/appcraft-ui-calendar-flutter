import 'package:intl/intl.dart';

/// A set of predefined date formats based on [DateFormat].
///
/// Provides named constructors for commonly used date display
/// formats in the calendar.
class ACDateFormat extends DateFormat {
  /// Abbreviated weekday name (for example, "Mon", "Tue").
  ///
  /// Pattern: `EEE`.
  ACDateFormat.weekday([String? locale]) : super('EEE', locale);

  /// Full month name and year (for example, "February 2026").
  ///
  /// Pattern: `LLLL yyyy`.
  ACDateFormat.monthYear([String? locale]) : super('LLLL yyyy', locale);

  /// Full month name (for example, "February").
  ///
  /// Pattern: `LLLL`.
  ACDateFormat.month([String? locale]) : super('LLLL', locale);
}
