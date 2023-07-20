import 'package:easy_ticket/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({Key? key}) : super(key: key);

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
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
      // Show a loading indicator while waiting for prefs to be initialized.
      return const CircularProgressIndicator();
    }
    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        if (authBloc.authStatus == AuthStatus.authenticated) {
          return const Row(
            children: [
              Text("Meus ingressos"),
            ],
          );
        } else {
          print("go page login");
          return const Login(backScreen: false);
        }
      },
    );
  }
}