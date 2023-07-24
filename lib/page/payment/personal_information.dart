import 'dart:math';

import 'package:easy_ticket/page/payment/address_information.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformation extends StatefulWidget {
  final double totalTicketValue;
  final int totalTicketCount;
  final dynamic tickets;

  const PersonalInformation({
    required this.totalTicketValue,
    required this.totalTicketCount,
    required this.tickets,
    Key? key
  }) : super(key: key);

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  late final _formKey;
  late final SharedPreferences prefs;
  late final dynamic tickets;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _phoneController;
  late TextEditingController _birthInputController;
  late final _nameFocus;
  late final _emailFocus;
  late final _cpfFocus;
  late final _phoneFocus;
  late final _birthFocus;

  late final double totalTicketValue;
  late final int totalTicketCount;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    tickets = widget.tickets;

    _nameController = TextEditingController();
    _birthInputController = TextEditingController();
    _emailController = TextEditingController();
    _cpfController = TextEditingController();
    _phoneController = TextEditingController();
    _birthInputController = TextEditingController();

    _nameFocus = FocusNode();
    _birthFocus = FocusNode();
    _emailFocus = FocusNode();
    _cpfFocus = FocusNode();
    _phoneFocus = FocusNode();

    _birthInputController.text = "";

    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;

    loadPreferences();

    super.initState();
  }

  void loadPreferences() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
      if(prefs.getString("personal_information_name") != null && prefs.getString("personal_information_name")!.isNotEmpty) {
        _nameController.text = prefs.getString("personal_information_name").toString();
      }
      if (prefs.getString("personal_information_email") != null && prefs.getString("personal_information_email")!.isNotEmpty) {
        _emailController.text = prefs.getString("personal_information_email").toString();
      }
      if (prefs.getString("personal_information_cpf") != null && prefs.getString("personal_information_cpf")!.isNotEmpty) {
        _cpfController.text = prefs.getString("personal_information_cpf").toString();
      }
      if (prefs.getString("personal_information_birth") != null && prefs.getString("personal_information_birth")!.isNotEmpty) {
        _birthInputController.text = prefs.getString("personal_information_birth").toString();
      }
      if (prefs.getString("personal_information_phone_number") != null && prefs.getString("personal_information_phone_number")!.isNotEmpty) {
        _phoneController.text = prefs.getString("personal_information_phone_number").toString();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: const Center(child: Text("Informações pessoais")),
            iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
            elevation: 0
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: const Center(child: Text("Informações pessoais")),
                  subtitle: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: "Nome do titular"),
                        keyboardType: TextInputType.text,
                        focusNode: _nameFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nome do titular é obrigatório.";
                          }
                          var textTrim = value.trim();
                          List<String> words = textTrim.split(' ');

                          if (words.length < 2) {
                            return "Por favor preencha o nome completo do titular";
                          }
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "E-mail"),
                        keyboardType: TextInputType.emailAddress,
                        focusNode: _emailFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "E-mail obrigatório.";
                          }

                          if (!isEmailValid(value)) {
                            return 'E-mail inválido.';
                          }

                        },
                      ),
                      TextFormField(
                        controller: _cpfController,
                        decoration: const InputDecoration(labelText: "CPF"),
                        keyboardType: TextInputType.number,
                        maxLength: 11,
                        focusNode: _cpfFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "CPF obrigatório.";
                          }
                          if (value.length < 11) {
                            return "CPF inválido.";
                          }
                        },
                      ),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(labelText: "Telefone"),
                        keyboardType: TextInputType.number,
                        focusNode: _phoneFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Telefone obrigatório.";
                          }
                        },
                      ),
                      TextFormField(
                        controller: _birthInputController,
                        decoration: const InputDecoration(labelText: "Data de nascimento (dd/MM/yyyy)"),
                        inputFormatters: [DateInputFormatter()],
                        focusNode: _birthFocus,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Data de nascimento obrigatório.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TotalTickets(totalTicketValue: totalTicketValue, totalTicketCount: totalTicketCount),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => AddressInformation(
                                totalTicketValue: totalTicketValue,
                                totalTicketCount: totalTicketCount,
                                tickets: tickets,
                                customer: generateCustomerObject()
                            )
                        ),
                      );
                    }
                  },
                  child: const Text("Continuar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  dynamic generateCustomerObject() {
    prefs.setString("personal_information_name", _nameController.text);
    prefs.setString("personal_information_email", _emailController.text);
    prefs.setString("personal_information_cpf", _cpfController.text);
    prefs.setString("personal_information_birth", _birthInputController.text);
    prefs.setString("personal_information_phone_number", _phoneController.text);

    var customer = {
      "name": _nameController.text,
      "email": _emailController.text,
      "cpf": _cpfController.text,
      "birth": _convertDateFormat(_birthInputController.text),
      "phone_number": _phoneController.text
    };

    return customer;
  }

  String _convertDateFormat(String inputDate) {
    try {
      final originalFormat = DateFormat('dd/MM/yyyy');
      final inputDateTime = originalFormat.parse(inputDate);
      final newFormat = DateFormat('yyyy-MM-dd');
      return newFormat.format(inputDateTime);
    } catch (e) {
      return ""; // Handle invalid date formats here, if necessary.
    }
  }

  bool isEmailValid(String email) {
    // Expressão regular para validar o formato do e-mail
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the input
    final String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    final StringBuffer formattedDate = StringBuffer();

    // Handle day (1st and 2nd characters)
    if (cleanedText.length >= 1) {
      formattedDate.write(cleanedText[0]);
      if (cleanedText.length > 1) {
        final int day = int.parse(cleanedText.substring(0, 2));
        if (day > 31) {
          return oldValue;
        }
        formattedDate.write(cleanedText[1]);
        // Add separator (/) after day if there are more characters
        if (cleanedText.length > 2) {
          formattedDate.write('/');
        }
      }
    }

    // Handle month (3rd and 4th characters)
    if (cleanedText.length >= 3) {
      formattedDate.write(cleanedText[2]);
      if (cleanedText.length > 3) {
        final int month = int.parse(cleanedText.substring(2, 4));
        if (month > 12) {
          return oldValue;
        }
        formattedDate.write(cleanedText[3]);
        // Add separator (/) after month if there are more characters
        if (cleanedText.length > 4) {
          formattedDate.write('/');
        }
      }
    }

    // Handle year (5th to 8th characters)
    if (cleanedText.length > 4) {
      formattedDate.write(cleanedText.substring(4, min(8, cleanedText.length)));
    }

    return TextEditingValue(
      text: formattedDate.toString(),
      selection: TextSelection.collapsed(offset: formattedDate.length),
    );
  }
}
