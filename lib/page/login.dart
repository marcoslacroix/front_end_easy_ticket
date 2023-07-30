import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/ticket/buy_tickets.dart';
import 'package:easy_ticket/page/home/home.dart';
import 'package:easy_ticket/page/perfil.dart';
import 'package:easy_ticket/page/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_bloc.dart';
import '../auth/auth_provider.dart';
import '../auth/token_manager.dart';
import '../enum/user_role.dart';
import '../util/urls.dart';
import '../util/util_routes.dart';
import 'forgot_password.dart';
import 'ticket/my_tickets.dart';

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
      token = responsePayload["token"];
    }
    return token;
  }

  Future<List<dynamic>> doRequestGetRoles(token) async {
    try {
      var url = Uri.parse(fetchUserRoles);
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
      );
      List<dynamic> roles = [];
      if (response.statusCode == 200) {
        Map<String, dynamic> responsePayload = jsonDecode(response.body);
        roles = responsePayload["roles"];
      }
      return roles;
    } catch (e) {
      print('Error occurred while fetching roles: $e');
      return [];
    }

  }

  void alertVerifyCredentials() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Favor verifique seu e-mail ou senha'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<String> requestLogin() async {
    String token = await doRequestLogin();
    return token;
  }

  void _handleLogin(BuildContext context) async {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      alertVerifyCredentials();
    }

    String token = await requestLogin();
    if (token.isNotEmpty) {
      await applyRoles(token);
      doLogin(token);
      chooseScreenToMove();
    } else {
      invalidLogin();
    }
  }

  void chooseScreenToMove() {
    if (event != null) {
      moveToTickets(context, event);
    } else if (screen == Screen.perfil) {
      moveToHome(context, SelectedScreen.perfil);
    } else if (screen == Screen.myTickets) {
      moveToHome(context, SelectedScreen.myTickets);
    } else {
      moveToHome(context, SelectedScreen.events);
    }
  }

  Future<void> applyRoles(token) async {
    List<dynamic> futureRoles = await doRequestGetRoles(token);
    updateRoles(futureRoles);
  }

  void updateRoles(futureRoles) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    List<String> roleStrings = futureRoles.cast<String>();
    List<UserRole> userRoles = [];
    userRoles = roleStrings.map((role) => parseUserRole(role)).toList();
    authProvider.updateRoles(userRoles);
    setState(() {
      prefs.setStringList("roles", roleStrings);
    });
  }

  void invalidLogin() {
    setState(() {
      _isButtonDisabled = false;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
      content: Text('Senha ou e-mail inválida'),
      behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void doLogin(value) {
    setState(() {
      String token = value;
      final authBloc = Provider.of<AuthBloc>(context, listen: false);
      authBloc.updateAuthStatus(AuthStatus.authenticated);
      prefs.setString('token', 'Bearer $token');
      TokenManager.instance.setToken('Bearer $token');
      _emailController.clear();
      _passwordController.clear();
    });
  }

  bool isEmailValid(String email) {
    // Expressão regular para validar o formato do e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
}