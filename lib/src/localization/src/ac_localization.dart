/// Abstract calendar localization class.
///
/// Defines the set of string resources required to display
/// calendar elements in various languages.
abstract class ACLocalization {
  /// Creates a localization instance.
  const ACLocalization();

  /// Title of the time input field.
  String get time;

  /// Calendar title.
  String get calendar;

  /// Title of the month selection dialog.
  String get selectMonth;

  /// Label of the confirmation button.
  String get done;
}
