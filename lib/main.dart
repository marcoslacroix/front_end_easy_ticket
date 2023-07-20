import 'package:easy_ticket/page/events.dart';
import 'package:easy_ticket/page/forgot_password.dart';
import 'package:easy_ticket/page/login.dart';
import 'package:easy_ticket/page/perfil.dart';
import 'package:easy_ticket/page/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_bloc.dart';
import 'page/home.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>(create: (_) => AuthBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Home(),
          '/login': (context) => const Login(backScreen: false),
          '/perfil': (context) => const Perfil(),
          '/register': (context) => const Register(),
          '/forgot-password': (context) => const ForgotPassword()
        },
      ),

    );
  }
}