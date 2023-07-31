import 'package:easy_ticket/auth/auth_bloc.dart';
import 'package:easy_ticket/buttom/logout.dart';
import 'package:easy_ticket/page/event/events.dart';
import 'package:easy_ticket/page/home/home.dart';
import 'package:easy_ticket/page/ticket/my_tickets.dart';
import 'package:easy_ticket/page/event/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/auth_roles.dart';
import '../../auth/token_manager.dart';
import 'login.dart';


class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late SharedPreferences prefs;
  bool isInitialized = false;
  var token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isInitialized = true;
      token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {

    if (!isInitialized) {
      return const CircularProgressIndicator();
    }
    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        if (authBloc.authStatus == AuthStatus.authenticated || token != null) {
          return SizedBox(
            width: double.infinity,
            child: Drawer(
              child: Column(
                children: [
                  const UserAccountsDrawerHeader(
                    accountName: Text("John Doe"),
                    accountEmail: Text("john.doe@example.com"),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text('Criar empresa'),
                          onTap: () {
                            // Handle create empresa
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text('Criar usuário com acesso a empresa'),
                          onTap: () {
                            // Handle create empresa
                          },
                        ),
                        // Add more menu items as needed
                      ],
                    ),
                  ),
                  Logout(prefs: prefs)
                ],
              ),
            ),
          );
        } else {
          return const Login(event: null, screen: Screen.perfil, selectedIndex: 0);
        }
      },
    );
  }
}