
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatDate(String dateString) {
    if (dateString.isEmpty) return '-';

    try {
      final date = DateTime.parse(dateString).toLocal();

      return DateFormat(
        'dd MMM yyyy, HH:mm',
        'id_ID',
      ).format(date);
    } catch (e) {
      return dateString;
    }
  }
}
