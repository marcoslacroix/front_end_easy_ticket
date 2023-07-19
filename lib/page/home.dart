
import 'package:easy_ticket/page/my_tickets.dart';
import 'package:easy_ticket/page/perfil.dart';
import 'package:easy_ticket/page/events.dart';
import 'package:easy_ticket/page/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          Center(
            child: Events(),
          ),
          Center(
            child: Search(),
          ),
          Center(
            child: MyTickets(),
          ),
          Center(
            child: Perfil(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Meus ingressos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Defina a cor do item selecionado
        unselectedItemColor: Colors.grey,
        //showSelectedLabels: true, // Remover rótulos dos itens selecionados
        //showUnselectedLabels: true, // Remover rótulos dos itens não selecionados
      ),
    );
  }
}