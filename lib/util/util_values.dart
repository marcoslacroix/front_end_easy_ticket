import 'package:intl/intl.dart';

String formatCurrency(double value) {
  final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR', symbol: 'R\$');
  return currencyFormat.format(value);
}

double realToCents(double real) {
  return real * 100.0;
}

