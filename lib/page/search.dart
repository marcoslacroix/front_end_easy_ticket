import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});


  @override
  _Search createState() => _Search();
}

class _Search extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text('Pesquisar'),
        ),
      ),
    );
  }
}