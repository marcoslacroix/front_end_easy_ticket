import 'dart:convert';
import 'dart:io';
import 'package:easy_ticket/page/terms.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../util/urls.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool passwordContainsNumber = false;
  bool passwordContainsUppercase = false;
  bool passwordContainsLowercase = false;
  bool passwordContainsSpecialChar = false;
  bool passwordContainsEigthToTwelveDigits = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _confirmPasswordController.addListener(updatePasswordContainsNumberAndUppercase);
    _passwordController = TextEditingController();
    _passwordController.addListener(updatePasswordContainsNumberAndUppercase);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordController.removeListener(updatePasswordContainsNumberAndUppercase);
    _passwordController.removeListener(updatePasswordContainsNumberAndUppercase);
    super.dispose();
  }

  void updatePasswordContainsNumberAndUppercase() {
    setState(() {
      String password = _passwordController.text;
      passwordContainsNumber = password.contains(RegExp(r'[0-9]'));
      passwordContainsLowercase = password.contains(RegExp(r'[a-z]'));
      passwordContainsSpecialChar = password.contains(RegExp(r'[^A-Za-z0-9]'));
      passwordContainsUppercase = password.contains(RegExp(r'[A-Z]'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: Column(
        children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Sobrenome',
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
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
                  width: 200,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                        child: Icon(
                          isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !isPasswordVisible,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirmar senha',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            isConfirmPasswordVisible = !isConfirmPasswordVisible;
                          });
                        },
                        child: Icon(
                          isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    obscureText: !isConfirmPasswordVisible,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      if (passwordContainsUppercase)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      Text(
                        'Letra maiúscula',
                        style: TextStyle(
                          color: passwordContainsUppercase ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      if (passwordContainsNumber)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      Text(
                        'Número',
                        style: TextStyle(
                          color: passwordContainsNumber ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      if (passwordContainsLowercase)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      Text(
                        'Letra minuscula',
                        style: TextStyle(
                          color: passwordContainsLowercase ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      if (passwordContainsSpecialChar)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      Text(
                        'Caractere especial',
                        style: TextStyle(
                          color: passwordContainsSpecialChar ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Row(
                    children: [
                      if (_passwordController.text != '' && _passwordController.text == _confirmPasswordController.text)
                        const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                      Flexible(
                        child: Text(
                          'As senhas correspondem',
                          style: TextStyle(
                            color: _passwordController.text != '' && _passwordController.text == _confirmPasswordController.text ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _handleRegister(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Defina a cor de fundo desejada
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(fontSize: 16), // Defina o estilo do texto, se necessário

                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Ao me cadastrar, concordo com os ',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                    TextSpan(
                      text: 'termos de uso',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Terms(),
                                  fullscreenDialog: false
                              ),
                                  (route) => true
                          );
                        },
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
      ),
    );
  }

  bool validateFields() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email obrigatório'),
        ),
      );
      return false;
    } else if (!_emailController.text.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email inválido'),
        ),
      );
      return false;
    } else if (!_emailController.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Email inválido'),
        ),
      );
      return false;
    } else if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Nome obrigatório'),
        ),
      );
      return false;
    } else if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Senha obrigatória"),
        ),
      );
      return false;
    } else if (_lastnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Sobrenome obrigatório"),
        ),
      );
      return false;
    } else if (!isPasswordStrong(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Senha deve conter pelo menos 8 caracteres, incluindo letras maiúsculas, minúsculas e números."),
        ),
      );
      return false;
    }

    return true;
  }

  bool isPasswordStrong(String password) {
    if (password.length < 8) {
      return false;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }

    return true;
  }


  Future<Response> doRegister() async {
    Map<String, dynamic> payload = {
      "email": _emailController.text,
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text,
      "name": _nameController.text,
      "lastname": _lastnameController.text
    };
    String jsonPayload = jsonEncode(payload);
    var url = Uri.parse(createUserUrl);
    var response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        body: jsonPayload
    );
    var body = response.body;
    return response;
  }

  void _handleRegister(BuildContext context) {
    if (validateFields()) {
      Future<Response> futureResponse = doRegister();

      futureResponse.then((response) => {
        if (response.statusCode == 200) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Home(),
                fullscreenDialog: false,
              ),
                  (route) => false
          )
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(jsonDecode(response.body)["error"] ?? "Houve um error"),
            ),
          )
        }
      });
    }
  }

}

