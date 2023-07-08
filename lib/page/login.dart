import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../auth/auth.dart';
import '../util/urls.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool isPasswordVisible = false;


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    final auth = Provider.of<Auth>(context, listen: false);
    Future<String> futureToken = doRequestLogin();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Favor verifique seu e-mail ou senha'),
        ),
      );
    } else {
      futureToken.then((value) =>
      {
        setState(() {
          String token = value;
          if (token.isNotEmpty) {
            auth.token = 'Bearer $token';
            _emailController.clear();
            _passwordController.clear();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Login efetuado'),
              ),
            );
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home())
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Senha inválida'),
              ),
            );
          }
        })
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Área exclusiva para clientes, faça o login ou crie um cadastro",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                TextField(
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
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () => _handleLogin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Register(),
                              fullscreenDialog: true,
                            ),
                                (route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Registrar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}