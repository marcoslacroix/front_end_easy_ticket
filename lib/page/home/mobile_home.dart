import 'package:easy_ticket/page/perfil.dart';
import 'package:easy_ticket/page/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../checking/scan_ticket.dart';
import '../event/events.dart';
import '../ticket/my_tickets.dart';

class MobileHome extends StatefulWidget {
  final int selectedIndex;
  const MobileHome({Key? key , required this.selectedIndex}) : super(key: key);

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
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

  final List<Widget Function()> _pages = [
        () => Center(
      child: Events(),
    ),
        () => Center(
      child: Search(),
    ),
        () => Center(
      child: ScanTicket(),
    ),
        () => Center(
      child: MyTickets(),
    ),
        () => Center(
      child: Perfil(),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex](),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: 'Pesquisar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            label: 'Checking',
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
