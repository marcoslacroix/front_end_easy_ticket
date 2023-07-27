import 'package:easy_ticket/page/ticket/buy_tickets.dart';
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
    String formattedDate = "";
    if (widget.event != null) {
      formattedDate = formatDate(widget.event?['period']);
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
                    child: Text('Evento: ${widget.event?['name'] ?? 'Nome do Evento Desconhecido'}'),
                  ),
                  Center(
                    child: Text('Data: ${formattedDate ?? ''}'),
                  ),
                  Center(
                    child: Text('Abertura: ${widget.event?['start'] ?? ''}'),
                  ),
                  Center(
                    child: Text('Descrição: ${widget.event?['description'] ?? ''}'),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyTickets(
                      event: widget.event
                  ),
                ),
              );
            },
            child: const Text('Comprar ingressos'),
          ),
        ),
      ),
    );
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }
}