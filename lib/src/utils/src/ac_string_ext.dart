/// Extension on [String] with helper formatting methods.
extension ACStringExt on String {
  /// Returns the string with its first letter capitalized.
  ///
  /// For an empty string, returns it unchanged.
  String toUpperCaseFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
