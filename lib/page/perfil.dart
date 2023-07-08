import 'package:easy_ticket/page/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../auth/token_checker.dart';
import 'login.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});


  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Auth(),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Perfil"),
              backgroundColor: Colors.green,
            ),
            body: const TokenChecker()
        )
    );
  }
}