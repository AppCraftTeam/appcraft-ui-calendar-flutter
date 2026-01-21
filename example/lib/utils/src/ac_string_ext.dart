extension ACStringExt on String {

  String toUpperCaseFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

}