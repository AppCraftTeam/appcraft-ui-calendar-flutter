import 'package:intl/intl.dart';

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