import 'package:flutter/material.dart';

import '../auth/token_checker.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});


  @override
  _MyTickets createState() => _MyTickets();
}

class _MyTickets extends State<MyTickets> {

  @override
  Widget build(BuildContext context) {
    return TokenChecker();

  }
}