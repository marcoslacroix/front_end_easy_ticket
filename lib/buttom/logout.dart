import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_bloc.dart';
import '../auth/auth_provider.dart';
import '../auth/token_manager.dart';
import '../page/home/home.dart';

class Logout extends StatefulWidget {
  final SharedPreferences prefs;

  const Logout({Key? key, required this.prefs}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        widget.prefs.remove("token");
        final authBloc = Provider.of<AuthBloc>(context, listen: false);
        authBloc.updateAuthStatus(AuthStatus.unauthenticated);
        TokenManager.instance.setToken("");
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.removeAllRoles();
        widget.prefs.setStringList("roles", []);
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
    );
  }
}
