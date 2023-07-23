import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/payment/credit_card.dart';
import 'package:easy_ticket/page/payment/pix.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/token_manager.dart';
import '../../util/urls.dart';


class Payment extends StatefulWidget {
  final dynamic maleTicketCountMap;
  final dynamic femaleTicketCountMap;
  final int totalTicketCount;
  final double totalTicketValue;
  final int companyId;
  final int eventId;

  const Payment({
    Key? key,
    required this.maleTicketCountMap,
    required this.femaleTicketCountMap,
    required this.totalTicketCount,
    required this.totalTicketValue,
    required this.companyId,
    required this.eventId
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final dynamic maleTicketCountMap;
  late final dynamic femaleTicketCountMap;
  late final double totalTicketValue;
  late final int totalTicketCount;
  late final int companyId;
  late final int eventId;
  late final String token;
  late String? selectedPaymentMethod;
  late String? selectedBandType;
  late bool showCreditCardForm ;
  late bool showPersonalInformation;
  late SharedPreferences prefs;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cpfController;
  late TextEditingController _phoneController;
  late TextEditingController _birthInputController;
  late String birthDate;
  late final _nameFocus;
  late final _emailFocus;
  late final _cpfFocus;
  late final _phoneFocus;
  late final _birthFocus;

  late TextEditingController _streetController;
  late TextEditingController _streetNumberController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _zipcodeController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late final _streetFocus;
  late final _streetNumberFocus;
  late final _neighborhoodFocus;
  late final _zipcodeFocus;
  late final _cityFocus;
  late final _stateFocus;

  late TextEditingController _cardNumberController;
  late TextEditingController _cvvController;
  late TextEditingController _expirationMonthController;
  late TextEditingController _expirationYearController;
  late final _cardNumberFocus;
  late final _cvvFocus;
  late final _expirationMonthFocus;
  late final _expirationYearFocus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    companyId = widget.companyId;
    eventId = widget.eventId;
    showCreditCardForm = false;
    showPersonalInformation = false;
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

    _streetController = TextEditingController();
    _streetNumberController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _zipcodeController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();

    _streetFocus = FocusNode();
    _streetNumberFocus = FocusNode();
    _neighborhoodFocus = FocusNode();
    _zipcodeFocus = FocusNode();
    _cityFocus = FocusNode();
    _stateFocus = FocusNode();

    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();
    _expirationMonthController = TextEditingController();
    _expirationYearController = TextEditingController();

    _cardNumberFocus = FocusNode();
    _cvvFocus = FocusNode();
    _expirationMonthFocus = FocusNode();
    _expirationYearFocus = FocusNode();

    selectedPaymentMethod = "";
    selectedBandType = "";
    birthDate = "";
    _birthInputController.text = ""; // Set the initial value of the text field
    maleTicketCountMap = widget.maleTicketCountMap;
    femaleTicketCountMap = widget.femaleTicketCountMap;
    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;
    token = TokenManager.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Center(child: Text("Pagamento")),
          iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
          elevation: 0
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text("Cartão de Crédito"),
                      value: 'credit_card',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value.toString();
                          showCreditCardForm = true;
                        });
                      },
                    ),
                    RadioListTile(
                      title: const Text("PIX"),
                      value: 'pix',
                      groupValue: selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value.toString();
                          showCreditCardForm = false;
                          showPersonalInformation = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (showCreditCardForm)
                Card(
                  child: ListTile(
                    title: const Center(child: Text("Cartão de crédito")),
                    subtitle: Column(
                      children: [
                        RadioListTile(
                          title: const Text("VISA") ,
                          value: "visa",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              showPersonalInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("MASTERCARD") ,
                          value: "mastercard",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              showPersonalInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("ELO") ,
                          value: "elo",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              showPersonalInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("AMEX") ,
                          value: "amex",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              showPersonalInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text("HIPERCARD") ,
                          value: "hipercard",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              showPersonalInformation = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
              if (showPersonalInformation)
                Card(
                  child: ListTile(
                    title: const Center(child: Text("Cartão de crédito")),
                    subtitle: Column(
                      children: [
                        TextFormField(
                          controller: _cardNumberController,
                          decoration: const InputDecoration(labelText: "Número"),
                          keyboardType: TextInputType.number,
                          focusNode: _cardNumberFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Número do cartão é obrigatório.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(labelText: "Código de segurança (CVV)"),
                          keyboardType: TextInputType.number,
                          focusNode: _cvvFocus,
                          maxLength: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Código de segurança (CVV) é obrigatório.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _expirationMonthController,
                          decoration: const InputDecoration(labelText: "Mês (MM)"),
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          focusNode: _expirationMonthFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Mês é obrigatório.';
                            }

                            int? month = int.tryParse(value);
                            if (month == null || month < 1 || month > 12) {
                              return 'Mês inválido (1 to 12)';
                            }
                            return null;
                          }
                        ),
                        TextFormField(
                          controller: _expirationYearController,
                          decoration: const InputDecoration(labelText: "Ano (YY)"),
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          focusNode: _expirationYearFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ano é obrigatório.';
                            }
                            int? year = int.tryParse(value);
                            if (year == null || year < 0 || year > 99) {
                              return 'Ano inválido (00 to 99)';
                            }
                            return null;
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              if (showPersonalInformation)
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
                          },
                        ),
                        TextFormField(
                          controller: _cpfController,
                          decoration: const InputDecoration(labelText: "CPF"),
                          keyboardType: TextInputType.number,
                          focusNode: _cpfFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "CPF obrigatório.";
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
                          decoration: const InputDecoration(labelText: "Data de nascimento"),
                          readOnly: true,
                          focusNode: _birthFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Data de nascimento obrigatório.";
                            }
                          },
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1960),
                              lastDate: DateTime(2101),// Set the locale to Brazilian Portuguese
                            );

                            if (pickedDate != null) {
                              String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                              String formattedDateYYYYmmDD = DateFormat('yyyy-MM-dd').format(pickedDate);

                              setState(() {
                                birthDate = formattedDateYYYYmmDD;
                                _birthInputController.text = formattedDate; // Set output date to TextField value.
                              });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              if (showPersonalInformation)
                Card(
                  child: ListTile(
                    title: const Center(child: Text("Endereço")),
                    subtitle: Column(
                      children: [
                        TextFormField(
                          controller: _streetController,
                          decoration: const InputDecoration(labelText: "Rua"),
                          keyboardType: TextInputType.streetAddress,
                          focusNode: _streetFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Rua obrigatório.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _streetNumberController,
                          decoration: const InputDecoration(labelText: "Número"),
                          keyboardType: TextInputType.number,
                          focusNode: _streetNumberFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Número do endereço é obrigatório.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _neighborhoodController,
                          decoration: const InputDecoration(labelText: "Bairro"),
                          keyboardType: TextInputType.text,
                          focusNode: _neighborhoodFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Bairro obrigatório.";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _zipcodeController,
                          decoration: const InputDecoration(labelText: "CEP"),
                          keyboardType: TextInputType.number,
                          focusNode: _zipcodeFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "CEP obrigatório";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(labelText: "Cidade"),
                          keyboardType: TextInputType.text,
                          focusNode: _cityFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Cidade obrigatório";
                            }
                          },
                        ),
                        TextFormField(
                          controller: _stateController,
                          decoration: const InputDecoration(labelText: "Estado"),
                          keyboardType: TextInputType.text,
                          focusNode: _stateFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Estado obrigatório.";
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text('Total de ingressos selecionados: $totalTicketCount'),
                    Text('Valor total: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalTicketValue)}'),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (selectedPaymentMethod == 'pix') {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (contex) => Pix(
                                  totalTicketValue: totalTicketValue,
                                  tickets: generateTicketsObject()
                                )
                            ),
                          (route) => false,
                        );
                      } else if (selectedPaymentMethod == 'credit_card') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) => CreditCard(
                                  totalTicketValue: totalTicketValue,
                                  tickets: generateTicketsObject()
                              )
                          ),
                        );
                      }
                    } else {
                      // Delay to allow time for the validator to update the state
                      await Future.delayed(Duration(milliseconds: 100));
                      FocusScope.of(context).requestFocus(_expirationMonthFocus);
                    }
                  },
                  child: const Text("Continua"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  dynamic generateTicketsObject() {
    var tickets = [];

    if (maleTicketCountMap != null) {
      maleTicketCountMap.forEach((key, value) {
        if (value > 0) {
          var ticket = {
            "lots": key,
            "quantity": value,
            "type": "MALE"
          };
          tickets.add(ticket);
        }

      });
    }

    if (femaleTicketCountMap != null) {
      femaleTicketCountMap.forEach((key, value) {
        if (value > 0) {
          var ticket = {
            "lots": key,
            "quantity": value,
            "type": "FEMALE"
          };
          tickets.add(ticket);
        }
      });
    }

    var params = {
      "event": eventId,
      "company": companyId,
      "tickets": tickets
    };

    return params;

  }

}
