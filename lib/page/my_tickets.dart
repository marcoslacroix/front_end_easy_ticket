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
  var token;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        if (authBloc.authStatus == AuthStatus.authenticated || token != null) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text("Meus ingressos"),),
            ),
            body: const Row(
              children: [
                Text("Meus ingressos"),
              ],
            ),
          );
        } else {
          print("go page login");
          return const Login(eventId: null, screen: Screen.myTickets, selectedIndex: 3);
        }
      },
    );
  }
}