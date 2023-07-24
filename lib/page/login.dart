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
import '../auth/token_manager.dart';
import '../util/urls.dart';
import 'forgot_password.dart';
import 'my_tickets.dart';

enum Screen {
  perfil,
  myTickets,
  buyTickets
}

class Login extends StatefulWidget {
  final dynamic event;
  final Screen screen;
  final int selectedIndex;

  const Login({
    Key? key,
    required this.event,
    required this.screen,
    required this.selectedIndex
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {
  late final _formKey;
  late final SharedPreferences prefs;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isPasswordVisible = false;
  late dynamic event;
  late Screen screen;
  late final int? selectedIndex;
  late final _passwordFocus;
  late final _emailFocus;

  late bool _isButtonDisabled;


  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    setState(() {
      selectedIndex = widget.selectedIndex;
      screen = widget.screen;
      event = widget.event;
    });
    _isButtonDisabled = false;
    loadPreferences();
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocus = FocusNode();
    _emailFocus = FocusNode();
  }

  void loadPreferences() async {
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
    return Form(
      key: _formKey,
      child: Scaffold(
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
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      focusNode: _emailFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "E-mail obrigatório.";
                        }

                        if (!isEmailValid(value)) {
                          return 'E-mail inválido.';
                        }
                      },
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
                    child: TextFormField(
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      focusNode: _passwordFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password obrigatório.";
                        }
                      },
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
                    onPressed: _isButtonDisabled
                    ? null
                    : () => {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isButtonDisabled = true;
                        }),
                        _handleLogin(context)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),

                    child: _isButtonDisabled
                    ? const SizedBox( // Show loading indicator when _isButtonDisabled is true
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text('Acessar'),
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
            TokenManager.instance.setToken('Bearer $token');
            _emailController.clear();
            _passwordController.clear();
            if (event != null) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => BuyTickets(event: event)
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
            setState(() {
              _isButtonDisabled = false;
            });
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
  bool isEmailValid(String email) {
    // Expressão regular para validar o formato do e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}