import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});


  @override
  _Events createState() => _Events();
}

class _Events extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Eventos"),
        backgroundColor: Colors.green,
      ),
      body: Container(

      ),
    );
  }
}