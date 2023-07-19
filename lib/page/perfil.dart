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

    if (token != null && token.isNotEmpty) {
      return Row(
        children: [
          TextButton(
            onPressed: () async {
              prefs.remove("token");
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                  fullscreenDialog: true,
                ),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          )
        ],
      );
    } else {
      print("go page login");
      return const Login();
    }
  }
}