import 'package:easy_ticket/page/home/mobile_home.dart';
import 'package:easy_ticket/page/home/web_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_bloc.dart';
import '../my_tickets.dart';
import '../perfil.dart';
import '../events.dart';
import '../search.dart';

enum SelectedScreen {
  events,
  search,
  myTickets,
  perfil,
}

class Home extends StatefulWidget {
  final SelectedScreen selectedScreen;
  const Home({super.key, required this.selectedScreen});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences prefs;
  int _selectedIndex = 0;

  var token;

  @override
  void initState() {
    super.initState();
    setState(() {
      getToken();
    });

    switch (widget.selectedScreen) {
      case SelectedScreen.events:
        setState(() {
          _selectedIndex = 0;
        });
        break;
      case SelectedScreen.search:
        setState(() {
          _selectedIndex = 1;
        });
        break;
      case SelectedScreen.myTickets:
        setState(() {
          _selectedIndex = 2;
        });
        break;
      case SelectedScreen.perfil:
        setState(() {
          _selectedIndex = 3;
        });
        break;
      default:
        _selectedIndex = 0;
    }
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      final authBloc = Provider.of<AuthBloc>(context, listen: false);
      authBloc.checkAuthentication(token);
    });
  }


  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebHome(selectedIndex: _selectedIndex);
    } else {
      return MobileHome(selectedIndex: _selectedIndex);
    }
  }
}