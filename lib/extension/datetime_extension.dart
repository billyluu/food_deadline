import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  String toYYYYMMDD() {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}