import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});


  @override
  _Terms createState() => _Terms();
}

class _Terms extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Termos de uso"),
        backgroundColor: Colors.green,
      ),
      body: Container(

      ),
    );
  }
}