import 'package:flutter/cupertino.dart';

class CreditCard extends StatefulWidget {
  final dynamic tickets;
  final double totalTicketValue;

  const CreditCard({
    required this.totalTicketValue,
    required this.tickets,
    Key? key}) : super(key: key);

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
