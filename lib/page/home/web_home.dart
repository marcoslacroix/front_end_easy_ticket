import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../event/events.dart';
import '../ticket/my_tickets.dart';
import '../user/perfil.dart';
import '../event/search.dart';

class WebHome extends StatefulWidget {
  final int selectedIndex;
  const WebHome({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  late int _selectedIndex;

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Menu lateral (drawer) para a web
          Drawer(
            width: 150,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: const Text('Eventos'),
                  onTap: () {
                    _onItemTapped(0);
                  },
                ),
                ListTile(
                  title: const Text('Pesquisar'),
                  onTap: () {
                    _onItemTapped(1);
                  },
                ),
                ListTile(
                  title: const Text('Meus ingressos'),
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
                ListTile(
                  title: const Text('Perfil'),
                  onTap: () {
                    _onItemTapped(3);
                  },
                ),
              ],
            ),
          ),
          // Conteúdo da página
          Expanded(
            child: IndexedStack(
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
          ),
        ],
      ),
    );
  }
}
