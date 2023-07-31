import 'dart:convert';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:easy_ticket/util/urls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import '../../auth/token_manager.dart';
import '../../util/util_dialog.dart';
import '../../util/util_routes.dart';
import '../../util/util_values.dart';

class TicketInformation extends StatefulWidget {
  final dynamic lot;
  final dynamic event;
  const TicketInformation({Key? key, required this.lot, required this.event}) : super(key: key);

  @override
  State<TicketInformation> createState() => _TicketInformationState();
}

class _TicketInformationState extends State<TicketInformation> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _quantityMaleController;
  late TextEditingController _priceMaleController;

  late TextEditingController _quantityFemaleController;
  late TextEditingController _priceFemaleController;
  late bool _isButtonDisabled;
  late String token;

  final _quantityMaleFocus = FocusNode();
  final _priceMaleFocus = FocusNode();
  final _quantityFemaleFocus = FocusNode();
  final _priceFemaleFocus = FocusNode();

  @override
  void initState() {
    _isButtonDisabled = false;
    _quantityMaleController = TextEditingController();
    _priceMaleController = TextEditingController();

    _quantityFemaleController = TextEditingController();
    _priceFemaleController = TextEditingController();
    token = TokenManager.instance.getToken();
    super.initState();
  }

  @override
  void dispose() {
    _priceMaleController.dispose();
    _priceMaleFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Ingressos")),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Column(
                    children: [
                      const Text("Ingressos masculino", style: TextStyle(color: Colors.blue)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _quantityMaleController,
                          decoration: const InputDecoration(
                              labelText: "Quantidade",
                              border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          focusNode: _quantityMaleFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Quantidade obrigatória.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _priceMaleController,
                          decoration: const InputDecoration(
                            labelText: "Valor",
                            border: OutlineInputBorder(),
                          ),
                          focusNode: _priceMaleFocus,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CurrencyTextInputFormatter(
                            symbol: "R\$",
                            locale: "pt-BR"
                          )],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Valor obrigatória.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: Column(
                    children: [
                      const Text("Ingressos feminino", style: TextStyle(color: Colors.pinkAccent)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _quantityFemaleController,
                          decoration: const InputDecoration(
                              labelText: "Quantidade",
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.sentences,
                          keyboardType: TextInputType.number,
                          focusNode: _quantityFemaleFocus,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Quantidade obrigatória.";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _priceFemaleController,
                          decoration: const InputDecoration(
                            labelText: "Valor",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: _priceFemaleFocus,
                          inputFormatters: [CurrencyTextInputFormatter(
                              symbol: "R\$",
                              locale: "pt-BR"
                          )],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Valor obrigatória.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () => _isButtonDisabled ? null : _saveTicket(),
          child:
          _isButtonDisabled ? const SizedBox( // Show loading indicator when _isButtonDisabled is true
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ) :
          const Text("Salvar"),
        ),
      ),
    );
  }

  void _saveTicket() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = true;
      });
    }

    await requestCreateTickets(context);
    setState(() {
      _isButtonDisabled = false;
    });
  }

  Future<void> requestCreateTickets(context) async {
    try {
      var body = getBodyTicket();
      String jsonPayload = jsonEncode(body);

      final url = Uri.parse(createTicketUrl);
      var response = await http.post(
        url,
        body: jsonPayload,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
      );

      if (response.statusCode == 201) {
        moveToSuccessCreatedTicket(context);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        showErrorDialog(context, jsonData['error'], "Error");
      }
    } catch(e) {
      print('Error occurred while create event: $e');
    }
  }

  dynamic getBodyTicket() {
    String malePrice = _priceMaleController.text.substring(3);
    double doubleMalePrice = double.parse(malePrice.replaceAll(",", "."));

    String femalePrice = _priceFemaleController.text.substring(3);
    double doubleFemalePrice = double.parse(femalePrice.replaceAll(",", "."));

    String startSalesString = widget.lot['startSales'];
    DateTime startSalesStringDate = DateFormat('dd/MM/yyyy').parse(startSalesString);
    String formattedStartSalesStringDate = DateFormat('yyyy-MM-dd').format(startSalesStringDate);

    String endSalesString = widget.lot['endSales']; // Assuming eventData['period'] is a string in the format "dd/MM/yyyy"
    DateTime endSalesStringDate = DateFormat('dd/MM/yyyy').parse(endSalesString);
    String formattedEndSalesStringDate = DateFormat('yyyy-MM-dd').format(endSalesStringDate);

    return {
      "event": {
        "id": widget.event['id']
      },
      "lots": {
        "description": widget.lot['description'],
        "startSales": formattedStartSalesStringDate,
        "endSales": formattedEndSalesStringDate,
      },
      "tickets": [
        {
          "quantity": _quantityMaleController.text,
          "price": doubleMalePrice * 100,
          "type": 'MALE'
        },
        {
          "quantity": _quantityFemaleController.text,
          "price": doubleFemalePrice * 100,
          "type": 'FEMALE'
        }
      ]
    };
  }

}


class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}