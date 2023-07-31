import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';

class SuccessNewEvent extends StatefulWidget {
  const SuccessNewEvent({Key? key}) : super(key: key);

  @override
  State<SuccessNewEvent> createState() => _SuccessNewEventState();
}

class _SuccessNewEventState extends State<SuccessNewEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Home(selectedScreen: SelectedScreen.events)),
                    (route) => false,
              ); // Navigate back to the previous screen (home page)
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: Colors.green,
            ),
            SizedBox(height: 20),
            Text(
              "Evento criado com sucesso!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
