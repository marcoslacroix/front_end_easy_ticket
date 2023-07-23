import 'package:easy_ticket/page/buy_tickets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Event extends StatefulWidget {
  final dynamic event;

  const Event({required this.event, Key? key}) : super(key: key);

  @override
  _Event createState() => _Event();
}

class _Event extends State<Event> {

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    String formattedDate = "";
    if (event != null) {
      formattedDate = formatDate(event?['period']);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Evento")),
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Text('Evento: ${event?['name'] ?? 'Nome do Evento Desconhecido'}'),
                  ),
                  Center(
                    child: Text('Data: ${formattedDate ?? ''}'),
                  ),
                  Center(
                    child: Text('Abertura: ${event?['start'] ?? ''}'),
                  ),
                  Center(
                    child: Text('Descrição: ${event?['description'] ?? ''}'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyTickets(
                        event: event
                    ),
                  ),
                );
              },
              child: const Text('Comprar ingressos'),
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

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }
}