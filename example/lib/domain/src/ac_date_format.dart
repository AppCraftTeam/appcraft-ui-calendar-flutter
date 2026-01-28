import 'package:intl/intl.dart';
// TODO: Add to extension
class ACDateFormat extends DateFormat {

  ACDateFormat.weekday([
    String? locale
  ]) : super('EEE', locale);

  ACDateFormat.monthYear([
    String? locale
  ]) : super('LLLL yyyy', locale);

  ACDateFormat.month([
    String? locale
  ]) : super('LLLL', locale);

}