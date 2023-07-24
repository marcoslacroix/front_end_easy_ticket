import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class TotalTickets extends StatelessWidget {
  final double totalTicketValue;
  final int totalTicketCount;

  const TotalTickets({
    Key? key,
    required this.totalTicketCount,
    required this.totalTicketValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text('Total de ingressos selecionados: $totalTicketCount'),
          Text('Valor total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalTicketValue)}'),
        ],
      ),
    );
  }
}
