import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String todayKey() {
    return DateFormat('yyyyMMdd').format(DateTime.now());
  }

  static bool isEmpty(String? s) => s == null || s.trim().isEmpty;
}
