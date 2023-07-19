import 'package:easy_ticket/page/login.dart';
import 'package:flutter/material.dart';
import 'page/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Home()
    );
  }
}
