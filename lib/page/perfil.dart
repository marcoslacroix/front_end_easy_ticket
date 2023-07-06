import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});


  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: Container(
        // Widget do corpo da tela
      ),
    );
  }
}