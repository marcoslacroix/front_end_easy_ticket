import 'package:easy_ticket/auth/auth_roles.dart';
import 'package:easy_ticket/page/home/mobile_home.dart';
import 'package:easy_ticket/page/home/web_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_bloc.dart';
import '../../auth/token_manager.dart';
import '../../enum/user_role.dart';
import '../ticket/my_tickets.dart';
import '../user/perfil.dart';
import '../event/events.dart';
import '../event/search.dart';

enum SelectedScreen {
  events,
  search,
  checking,
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
  late String token;
  List<UserRole>? listRoles;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token") ?? "";
      final authBloc = Provider.of<AuthBloc>(context, listen: false);
      authBloc.checkAuthentication(token);
      TokenManager.instance.setToken(token);
      getRoles();
    });
  }

  void getRoles() {
    final authRoles = Provider.of<AuthRoles>(context, listen: false);
    List<String> roles = prefs.getStringList("roles") ?? [];
    List<UserRole> userRoles = roles.map((role) => parseUserRole(role)).toList();
    setState(() {
      listRoles = userRoles;
      authRoles.updateRoles(userRoles);
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.selectedScreen) {
      case SelectedScreen.events:
        _selectedIndex = 0;
        break;
      case SelectedScreen.search:
        _selectedIndex = 1;
        break;
      case SelectedScreen.myTickets:
        _selectedIndex = 2;
        break;
      case SelectedScreen.perfil:
        _selectedIndex = 3;
        break;
      case SelectedScreen.checking:
        if (listRoles != null && listRoles!.contains(UserRole.CHECKING_TICKET)) {
          _selectedIndex = 4;
        }
        break;
      default:
        _selectedIndex = 0;
    }

    if (kIsWeb) {
      return WebHome(selectedIndex: _selectedIndex);
    } else {
      return listRoles != null
          ? MobileHome(selectedIndex: _selectedIndex)
          : const CircularProgressIndicator(); // You can use a different widget while waiting for listRoles to be initialized
    }
  }
}