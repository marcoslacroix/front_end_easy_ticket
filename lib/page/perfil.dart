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

    return Consumer<AuthBloc>(
        builder: (context, authBloc, _) {
          print("Login token: $token");
          var status = authBloc.authStatus;
          print("authBloc: $status");
          print("------------");
          if (authBloc.authStatus == AuthStatus.authenticated) {
            return Scaffold(
              body: Row(
                children: [
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        prefs.remove("token");
                        final authBloc = Provider.of<AuthBloc>(context, listen: false);
                        authBloc.updateAuthStatus(AuthStatus.unauthenticated);

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
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Login(backScreen: false, eventId: null,);
          }
        }
    );
  }
}

