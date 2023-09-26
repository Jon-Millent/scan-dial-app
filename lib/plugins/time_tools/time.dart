import 'package:intl/intl.dart';

class TimeTools {

  static String formatDateTime (DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String getNowDate () {
    return TimeTools.formatDateTime(DateTime.now());
  }

}