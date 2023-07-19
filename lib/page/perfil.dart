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
  late Future<SharedPreferences> prefsFuture;

  @override
  void initState() {
    super.initState();
    prefsFuture = SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: prefsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for prefs to be initialized.
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Handle the case when an error occurs while initializing prefs.
          return const Text("Error initializing SharedPreferences");
        }

        final SharedPreferences prefs = snapshot.data!;

        var token = prefs.getString("token");

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
      },
    );
  }
}