/// Represents the selection state of a day in the calendar.
///
/// This enum defines the various visual and logical states
/// that a day can have depending on the selection mode and its position.
enum ACDaySelectState {
  /// Single day selection mode
  /// Only one day can be selected at a time.
  single,

  /// Multiple day selection mode
  /// Several independent days can be selected.
  multi,

  /// The first day of the selected date range.
  startOfRange,

  /// The last day of the selected date range.
  endOfRange,

  /// A day that lies between the start and end of the selected date range.
  middleInRange
}
