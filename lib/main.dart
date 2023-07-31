import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_bloc.dart';
import 'auth/auth_roles.dart';
import 'page/home/home.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>(
            create: (_) => AuthBloc(),
        ),
        ChangeNotifierProvider(
            create: (context) => AuthRoles()
        )
      ],
      child: const MaterialApp(
        home: Home(selectedScreen: SelectedScreen.events),
      ),

    );
  }
}