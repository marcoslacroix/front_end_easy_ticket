import 'package:easy_ticket/page/events.dart';
import 'package:easy_ticket/page/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_bloc.dart';
import 'page/home.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // todo quando abrir o app setar authenticado true se tiver token
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>(
            create: (_) => AuthBloc(),
        ),
      ],
      child: const MaterialApp(
        home: Home(selectedScreen: SelectedScreen.events),
      ),

    );
  }
}