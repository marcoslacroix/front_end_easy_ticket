import 'package:flutter/material.dart';

import '../auth/token_checker.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});


  @override
  _Perfil createState() => _Perfil();
}

class _Perfil extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return TokenChecker();

  }

}