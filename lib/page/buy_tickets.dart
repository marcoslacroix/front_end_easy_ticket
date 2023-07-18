import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BuyTickets extends StatefulWidget {
  final dynamic event;
  const BuyTickets({required this.event, Key? key}) : super(key: key);
  @override
  State<BuyTickets> createState() => _BuyTicketsState();
}

class _BuyTicketsState extends State<BuyTickets> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: event?['lots'].length,
              itemBuilder: (context, index) {
                final lot = event?['lots'][index];
                final tickets = lot?['tickets'] ?? [];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.red,
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(child: Text('Lot ID: ${lot?['loteId']}')),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tickets.length,
                          itemBuilder: (context, ticketIndex) {
                            final ticket = tickets[ticketIndex];
                            String realValue = centsToReal(ticket['price']);

                            return ListTile(
                              title: Center(child: Text('Type: ${ticket['type']}')),
                              subtitle: Center(child: Text('Quantity: ${ticket['quantity']} - R\$ $realValue')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyTickets(event: event),
                  ),
                );
              },
              child: const Text('Contiuar'),
            ),
          ),
        ],
      ),
    );
  }

  String centsToReal(int cents) {
    double realValue = cents / 100.0;
    return realValue.toStringAsFixed(2);
  }
}
