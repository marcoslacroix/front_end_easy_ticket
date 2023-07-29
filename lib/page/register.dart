import 'dart:convert';
import 'dart:io';
import 'package:easy_ticket/page/terms.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../util/urls.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final _formKey;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late final _emailFocus;
  late final _nameFocus;
  late final _lastnameFocus;
  late final _passwordFocus;
  late final _confirmPasswordFocus;

  bool passwordContainsNumber = false;
  bool passwordContainsUppercase = false;
  bool passwordContainsLowercase = false;
  bool passwordContainsSpecialChar = false;
  bool passwordContainsEigthToTwelveDigits = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late bool _isButtonDisabled;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();

    _isButtonDisabled = false;

    _emailFocus = FocusNode();
    _nameFocus = FocusNode();
    _lastnameFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();

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
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(labelText: 'Nome'),
                        focusNode: _nameFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nome obrigatório.";
                          }
                        },
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
                      controller: _lastnameController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      focusNode: _lastnameFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Sobrenome obrigatório.";
                        }
                      },
                      decoration: const InputDecoration(labelText: 'Sobrenome'),
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
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocus,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "E-mail obrigatório.";
                        }
                        if (!isEmailValid(value)) {
                          return 'E-mail inválido.';
                        }
                      },
                      decoration: const InputDecoration(labelText: 'E-mail'),
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
                          return "Senha obrigatório.";
                        }
                        if (!passwordContainsUppercase) {
                          return "A senha deve ter pelo menos uma letra maiuscula";
                        }
                        if (!passwordContainsSpecialChar) {
                          return "A senha deve conter pelo menos um caracter especial.";
                        }
                        if (!passwordContainsNumber) {
                          return "A senha deve conter pelo menos um número.";
                        }
                        if (!passwordContainsLowercase) {
                          return "A senha deve conter pelo menos uma letra minuscula.";
                        }
                      },
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
                    width: 250,
                    child: TextFormField(
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.next,
                      focusNode: _confirmPasswordFocus,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Senha obrigatório.";
                        }
                        if (!passwordContainsUppercase) {
                          return "A senha deve ter pelo menos uma letra maiuscula";
                        }
                        if (!passwordContainsSpecialChar) {
                          return "A senha deve conter pelo menos um caracter especial.";
                        }
                        if (!passwordContainsNumber) {
                          return "A senha deve conter pelo menos um número.";
                        }
                        if (!passwordContainsLowercase) {
                          return "A senha deve conter pelo menos uma letra minuscula.";
                        }
                      },
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
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
                    width: 250,
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
                    width: 250,
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
                    width: 250,
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
                    width: 250     ,
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
                    onPressed: _isButtonDisabled
                    ? null
                    : () =>{
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isButtonDisabled = true;
                        }),
                        _handleRegister(context)
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Defina a cor de fundo desejada
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
                    : const Text('Registrar', style: TextStyle(fontSize: 16), // Defina o estilo do texto, se necessário

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
        ),

      ),
    );
  }

  bool validateFields() {
    if (_emailController.text.isEmpty) {
      showMessageError("Email obrigatório");
      return false;
    } else if (!_emailController.text.contains("@")) {
      showMessageError("Email inválido");
      return false;
    } else if (!_emailController.text.contains(".")) {
      showMessageError("Email inválido");
      return false;
    } else if (_nameController.text.isEmpty) {
      showMessageError("Nome obrigatório");
      return false;
    } else if (_passwordController.text.isEmpty) {
      showMessageError("Senha obrigatória");
      return false;
    } else if (_lastnameController.text.isEmpty) {
      showMessageError("Sobrenome obrigatório");
      return false;
    } else if (!isPasswordStrong(_passwordController.text)) {
      showMessageError("Senha deve conter pelo menos 8 caracteres, incluindo letras maiúsculas, minúsculas e números.");
      return false;
    }

    return true;
  }

  void showMessageError(text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
    );
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


  Future<void> doRegister() async {
    try {
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

      if (response.statusCode == 201) {
        returnToPreviusScreen();
      } else if (response.statusCode == 400) {
        Map<String, dynamic> responsePayload = jsonDecode(response.body);
        _handleError(responsePayload['error']);
      }
    } catch(e) {
      print('Error occurred while register: $e');
    }

  }

  void returnToPreviusScreen() {
    Navigator.pop(context);
  }

  void _handleError(error) {
    setState(() {
      _isButtonDisabled = false;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? "Houve um erro"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRegister(BuildContext context) async {
    if (validateFields()) {
      await doRegister();
    }
  }

  bool isEmailValid(String email) {
    // Expressão regular para validar o formato do e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

}

