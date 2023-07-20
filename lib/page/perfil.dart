import 'package:easy_ticket/auth/auth_bloc.dart';
import 'package:easy_ticket/page/events.dart';
import 'package:easy_ticket/page/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final authBloc = Provider.of<AuthBloc>(context);

    if (authBloc.authStatus == AuthStatus.authenticated) {
      return Row(
        children: [
          TextButton(
            onPressed: () async {
              prefs.remove("token");
              authBloc.updateAuthStatus(AuthStatus.unauthenticated);
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: const Text("Logout"),
          )
        ],
      );
    } else {
      print("go page login");
      // If the user is not authenticated, navigate to the login page.
      return const Login(backScreen: false);
    }
  }
}