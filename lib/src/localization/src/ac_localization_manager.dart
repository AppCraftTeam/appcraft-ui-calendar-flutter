import 'ac_localization.dart';

abstract class ACLocalizationManager {
  const ACLocalizationManager();

  ACLocalization localization(String? localeName);
}
