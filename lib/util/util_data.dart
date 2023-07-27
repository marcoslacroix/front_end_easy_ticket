
import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  DateTime date = DateTime.parse(dateStr);
  return DateFormat('dd/MM/yyyy').format(date);
}