import 'ac_localization.dart';

/// Abstract calendar localization manager.
///
/// Provides a method to obtain [ACLocalization] by locale name.
abstract class ACLocalizationManager {
  /// Creates a localization manager instance.
  const ACLocalizationManager();

  /// Returns the localization for the specified [localeName].
  ACLocalization localization(String? localeName);
}
