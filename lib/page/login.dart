import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/buy_tickets.dart';
import 'package:easy_ticket/page/home/home.dart';
import 'package:easy_ticket/page/perfil.dart';
import 'package:easy_ticket/page/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_bloc.dart';
import '../util/urls.dart';
import 'forgot_password.dart';
import 'my_tickets.dart';

enum Screen {
  perfil,
  myTickets,
  buyTickets
}

class Login extends StatefulWidget {
  final int? eventId;
  final Screen screen;
  final int selectedIndex;

  const Login({Key? key, required this.eventId, required this.screen, required this.selectedIndex}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  late final SharedPreferences prefs;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isPasswordVisible = false;
  int? eventId;
  late Screen screen;
  late final int? selectedIndex;


  @override
  void initState() {
    setState(() {
      selectedIndex = widget.selectedIndex;
      screen = widget.screen;
      eventId = widget.eventId;
    });
    getToken();
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void getToken() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
    });
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Area exclusiva para clientes, faça o login ou crie um cadastro",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible ? Icons.visibility : Icons
                              .visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Acessar'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                        fullscreenDialog: false,
                      ),
                          (route) => true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Quero me registrar',
                    style: TextStyle(
                      color: Colors.black, // Defina a cor do texto
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPassword(),
                        fullscreenDialog: false,
                      ),
                          (route) => true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      color: Colors.black, // Defina a cor do texto
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String> doRequestLogin() async {
    Map<String, dynamic> payload = {
      "email": _emailController.text,
      "password": _passwordController.text
    };
    String jsonPayload = jsonEncode(payload);

    String token = "";
    var url = Uri.parse(loginUrl);
    var response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonPayload
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responsePayload = jsonDecode(response.body);
      token = (responsePayload["token"]);
    }
    return token;
  }


  void _handleLogin(BuildContext context) {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    Future<String> futureToken = doRequestLogin();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favor verifique seu e-mail ou senha'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      futureToken.then((value) =>
      {
        setState(() {
          String token = value;
          if (token.isNotEmpty) {
            final authBloc = Provider.of<AuthBloc>(context, listen: false);
            authBloc.updateAuthStatus(AuthStatus.authenticated);
            prefs.setString('token', 'Bearer $token');
            _emailController.clear();
            _passwordController.clear();
            print("eventId: $eventId");
            if (eventId != null) {
              print("enviar para buy tickets");
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BuyTickets(event: eventId)
                ));
            } else if (screen == Screen.perfil) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(selectedScreen: SelectedScreen.perfil),
                ),
                (route) => false,
              );
            } else if (screen == Screen.myTickets) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const Home(selectedScreen: SelectedScreen.myTickets)
                ),
                (route) => false,
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(selectedScreen: SelectedScreen.events),
                  fullscreenDialog: true,
                ),
                (route) => false,
              );
            }
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Senha inválida'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        })
      });
    }
  }
}