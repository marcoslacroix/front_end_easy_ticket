import 'package:easy_ticket/page/user/perfil.dart';
import 'package:easy_ticket/page/event/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/auth_roles.dart';
import '../../enum/user_role.dart';
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
  List<UserRole> roles = [];


  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.selectedIndex;
    });
    super.initState();
    _initializeRoles();
  }

  void _initializeRoles() {
    final authRoles = Provider.of<AuthRoles>(context, listen: false);
    roles = authRoles.roles; // Initialize the roles list with the data from AuthRoles.
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthRoles>(
      builder: (context, authRoles, _) {
        roles = authRoles.roles;
        final List<Widget Function()> pages = [
              () => const Center(child: Events()),
              () => const Center(child: Search()),
              () => const Center(child: MyTickets()),
              () => const Center(child: Perfil()),
          if(roles.contains(UserRole.CHECKING_TICKET)) () => const Center(child: ScanTicket()),
        ];

        return Scaffold(
          body: pages[_selectedIndex](),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.event_available),
                label: 'Eventos',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Pesquisar',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Meus ingressos',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
              if(roles.contains(UserRole.CHECKING_TICKET))
                const BottomNavigationBarItem(
                  icon: Icon(Icons.camera_alt_outlined),
                  label: 'Checking',
                ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.grey,
          ),
        );
      }
    );
  }
}
