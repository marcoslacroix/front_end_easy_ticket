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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: Container(
        child: const Center(
          child: Text('Terms and Conditions'),
        ),
      ),
    );
  }
}