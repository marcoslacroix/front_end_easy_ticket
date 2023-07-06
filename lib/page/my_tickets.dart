import 'package:flutter/material.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});


  @override
  _MyTickets createState() => _MyTickets();
}

class _MyTickets extends State<MyTickets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus ingressos"),
      ),
      body: Container(
        // Widget do corpo da tela
      ),
    );
  }
}