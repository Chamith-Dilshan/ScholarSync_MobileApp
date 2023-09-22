import 'package:intl/intl.dart';

class FormatDate {
  static String formatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMMM').format(date);
    String year = DateFormat('y').format(date);

    String daySuffix = day.endsWith('1')
        ? 'st'
        : day.endsWith('2')
            ? 'nd'
            : day.endsWith('3')
                ? 'rd'
                : 'th';

    return '$day$daySuffix $month $year';
  }

  static String projectformatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String month = DateFormat('MM').format(date);
    String year = DateFormat('y').format(date);

    return '$day-$month-$year';
  }
}
