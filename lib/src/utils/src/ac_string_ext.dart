/// Расширение [String] вспомогательными методами форматирования.
extension ACStringExt on String {
  /// Возвращает строку с первой буквой в верхнем регистре.
  ///
  /// Для пустой строки возвращает её без изменений.
  String toUpperCaseFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
