import 'package:intl/intl.dart';

class DateUtilsHRMS {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static DateTime? tryParse(String? value) {
    try {
      return DateTime.parse(value ?? '');
    } catch (_) {
      return null;
    }
  }
}
