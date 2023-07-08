import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../auth/token_checker.dart';
import 'login.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});


  @override
  _MyTickets createState() => _MyTickets();
}

class _MyTickets extends State<MyTickets> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Auth(),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Meus ingressos"),
            backgroundColor: Colors.green,
          ),
          body: const TokenChecker()
      )
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Meus ingressos"),
        backgroundColor: Colors.green,
      ),
      body: const TokenChecker()
    );
  }
}