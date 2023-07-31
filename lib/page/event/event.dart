import 'package:easy_ticket/page/ticket/buy_tickets.dart';
import 'package:easy_ticket/page/ticket/new_ticket.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_roles.dart';
import '../../enum/user_role.dart';
import '../../util/util_data.dart';
import '../../util/util_routes.dart';

class Event extends StatefulWidget {
  final dynamic event;

  const Event({required this.event, Key? key}) : super(key: key);

  @override
  _Event createState() => _Event();
}

class _Event extends State<Event> {
  late List<UserRole> roles;

  @override
  void initState() {
    getRoles();
    super.initState();
  }
  void getRoles() {
    setState(() {
      roles = Provider.of<AuthRoles>(context, listen: false).roles;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "";
    if (widget.event != null) {
      formattedDate = formatDate(widget.event?['period']);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Evento")),
        iconTheme: const IconThemeData(color: Colors.black),
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
      floatingActionButton: roles.contains(UserRole.CREATE_TICKET) ? FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewTicket(event: widget.event)));
        },
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              moveToBuyTicket(context, widget.event);
            },
            child: const Text('Comprar ingressos'),
          ),
        ),
      ),
    );
  }

}