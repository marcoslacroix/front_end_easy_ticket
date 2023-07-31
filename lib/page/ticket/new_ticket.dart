import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTicket extends StatefulWidget {
  final event;

  const NewTicket({
    required this.event,
    Key? key
  }) : super(key: key);

  @override
  State<NewTicket> createState() => _NewTicketState();
}

class _NewTicketState extends State<NewTicket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Novo lote de ingressos")),
      ),
      body: const Text("Novo ingresso"),
    );
  }
}
