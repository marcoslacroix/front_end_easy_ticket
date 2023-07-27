import 'package:easy_ticket/auth/auth_bloc.dart';
import 'package:easy_ticket/page/event/events.dart';
import 'package:easy_ticket/page/home/home.dart';
import 'package:easy_ticket/page/ticket/my_tickets.dart';
import 'package:easy_ticket/page/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/token_manager.dart';
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
            return Scaffold(
              appBar: AppBar(
                title: const Center(child: Text("Meu perfil"),),
              ),
              body: Row(
                children: [
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        prefs.remove("token");
                        final authBloc = Provider.of<AuthBloc>(context, listen: false);
                        authBloc.updateAuthStatus(AuthStatus.unauthenticated);
                        TokenManager.instance.setToken("");
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(selectedScreen: SelectedScreen.perfil),
                            fullscreenDialog: true,
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Login(event: null, screen: Screen.perfil, selectedIndex: 0);
          }
        }
    );
  }
}

