import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../page/home.dart';
import '../page/login.dart';
import 'auth.dart';


class TokenChecker extends StatefulWidget {
  const TokenChecker({Key? key}) : super(key: key);

  @override
  _TokenCheckerState createState() => _TokenCheckerState();
}

class _TokenCheckerState extends State<TokenChecker> {
  late Future<void> _loadTokenFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<Auth>(context, listen: false);
    _loadTokenFuture = auth.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    return FutureBuilder(
      future: _loadTokenFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 10,
            height: 10,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        } else {
          return auth.token.isNotEmpty ?  const Home() : const Login();
        }
      },
    );
  }
}