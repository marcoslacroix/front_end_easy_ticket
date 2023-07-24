import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/payment/success_payment.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


import '../../auth/token_manager.dart';
import '../../util/urls.dart';

class CreditCard extends StatefulWidget {
  final dynamic tickets;
  final double totalTicketValue;
  final int totalTicketCount;
  final dynamic customer;
  final dynamic address;

  const CreditCard({
    required this.totalTicketValue,
    required this.tickets,
    required this.totalTicketCount,
    required this.customer,
    required this.address,
    Key? key}) : super(key: key);

  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  late final _formKey;
  static const routeName = '/credit_card'; // Add this line


  late TextEditingController _cardNumberController;
  late TextEditingController _cvvController;
  late TextEditingController _expirationMonthController;
  late TextEditingController _expirationYearController;
  late final _cardNumberFocus;
  late final _cvvFocus;
  late final _expirationMonthFocus;
  late final _expirationYearFocus;

  late bool showCardInformation;
  late String? selectedBandType;
  late final double totalTicketValue;
  late final int totalTicketCount;
  late String token;

  late dynamic installments;
  late int selectedInstallment;
  late bool _isButtonDisabled;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _isButtonDisabled = false;
    selectedInstallment = 1;
    installments = [];
    showCardInformation = false;
    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();
    _expirationMonthController = TextEditingController();
    _expirationYearController = TextEditingController();

    _cardNumberFocus = FocusNode();
    _cvvFocus = FocusNode();
    _expirationMonthFocus = FocusNode();
    _expirationYearFocus = FocusNode();

    selectedBandType = "";
    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;
    token = TokenManager.instance.getToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              title: const Center(
              child: Text("Forma de pagamento")),
              iconTheme: const IconThemeData(color: Colors.black),
              // Definir a cor do ícone de voltar
              elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Center(child: Text("Bandeira")),
                    subtitle: Column(
                      children: [
                        RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/visa.png',
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("VISA"),
                            ],
                          ),
                          value: "visa",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              getInstallments(value);
                              showCardInformation = true;
                            });
                          },

                        ),
                        RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/mastercard.png',
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("MASTERCARD"),
                            ],
                          ),
                          value: "mastercard",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              getInstallments(value);
                              showCardInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/elo.jpg',
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("ELO"),
                            ],
                          ),
                          value: "elo",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              getInstallments(value);
                              showCardInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/amex.png',
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("AMEX"),
                            ],
                          ),
                          value: "amex",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              getInstallments(value);
                              showCardInformation = true;
                            });
                          },
                        ),
                        RadioListTile(
                          title: Row(
                            children: [
                              Image.asset(
                                'assets/images/hipercard.png',
                                width: 24, // Adjust the width as needed
                                height: 24, // Adjust the height as needed
                              ),
                              const SizedBox(width: 8),
                              const Text("HIPERCARD"),
                            ],
                          ),
                          value: "hipercard",
                          groupValue: selectedBandType,
                          onChanged: (value) {
                            setState(() {
                              selectedBandType = value.toString();
                              getInstallments(value);
                              showCardInformation = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                if (showCardInformation)
                  Card(
                    child: ListTile(
                      title: const Center(child: Text("Cartão de crédito")),
                      subtitle: Column(
                        children: [
                          TextFormField(
                            controller: _cardNumberController,
                            decoration: const InputDecoration(labelText: "Número"),
                            textInputAction: TextInputAction.next,
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
                            textInputAction: TextInputAction.next,
                            focusNode: _cvvFocus,
                            maxLength: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Código de segurança (CVV) é obrigatório.";
                              }
                              if (value.length != 3) {
                                return "Código de segurça inválido";
                              }
                            },
                          ),
                          TextFormField(
                              controller: _expirationMonthController,
                              decoration: const InputDecoration(labelText: "Mês (MM)"),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              maxLength: 2,
                              focusNode: _expirationMonthFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Mês é obrigatório.';
                                }

                                int? month = int.tryParse(value);
                                if (month == null || month < 1 || month > 12) {
                                  return 'Mês inválido (1 a 12)';
                                }
                                return null;
                              }
                          ),
                          TextFormField(
                            controller: _expirationYearController,
                            decoration: const InputDecoration(
                                labelText: "Ano (YY)"),
                            maxLength: 2,
                            textInputAction: TextInputAction.next,
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
                          DropdownButton<int>(
                            value: selectedInstallment,
                            hint: const Text("Pacelas"),
                            onChanged: (value) {
                              setState(() {
                                selectedInstallment = value!;
                              });
                            },
                            items: installments.map<DropdownMenuItem<int>>((item) {
                              int installmentNumber = item['installment'];
                              double installmentValue = item['value'] / 100.0; // Convert from cents to real value
                              double total = installmentValue * installmentNumber;
                              return DropdownMenuItem<int>(
                                value: installmentNumber,
                                child: Text(
                                  '${installmentNumber == 1 ? 'Parcela' : 'Parcelas'} $installmentNumber de ${formatCurrency(installmentValue)} (${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(total)})',
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                TotalTickets(totalTicketValue: totalTicketValue,
                    totalTicketCount: totalTicketCount),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isButtonDisabled
                    ? null
                    : _onConfirmPayment,
                    child: _isButtonDisabled
                    ? const SizedBox( // Show loading indicator when _isButtonDisabled is true
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text("Confirmar pagamento"),
                  ),
                )

              ],
            ),
          ),
        )
    );
  }

  Map<String, String> _convertMapToStrings(Map<dynamic, dynamic> map) {
    final convertedMap = <String, String>{};
    map.forEach((key, value) {
      convertedMap[key.toString()] = value.toString();
    });
    return convertedMap;
  }

  double realToCents(double real) {
    return real * 100.0;
  }

  String formatCurrency(double value) {
    final currencyFormat = NumberFormat.currency(
        locale: 'pt_BR', symbol: 'R\$');
    return currencyFormat.format(value);
  }

  void _onConfirmPayment() async {
    if (_formKey.currentState!.validate() && selectedBandType!.isNotEmpty) {
      setState(() {
        _isButtonDisabled = true;
      });
      print("starting payment...");
      await requestPayment(context); // Pass the context here
    }
  }

  dynamic getBodyPayment() {
    print("selectedInstallment: $selectedInstallment");
    var body = {
      "company": widget.tickets['company'],
      "event": widget.tickets['event'],
      "tickets": widget.tickets['tickets'],
      "card": {
        "brand": selectedBandType,
        "number": _cardNumberController.text,
        "cvv": _cvvController.text,
        "expiration_month": _expirationMonthController.text,
        "expiration_year": _expirationYearController.text
      },
      "payment": {
        "credit_card": {
          "installments": selectedInstallment,
          "billing_address": {
            "street": widget.address['street'],
            "number": widget.address['number'],
            "neighborhood": widget.address['neighborhood'],
            "zipcode": widget.address['zipcode'],
            "city": widget.address['city'],
            "state": widget.address['state']
          },
          "customer": {
            "name": widget.customer['name'],
            "email": widget.customer['email'],
            "cpf": widget.customer['cpf'],
            "birth": widget.customer['birth'],
            "phone_number": widget.customer['phone_number'],
          }
        }
      }
    };
    return body;
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro no pagamento'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> requestPayment(context) async {
    try {
      var body = getBodyPayment();
      String jsonPayload = jsonEncode(body);

      print("body $body");
      final url = Uri.parse(payUrl);
      var response = await http.post(
        url,
        body: jsonPayload,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("response error: $jsonData");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessPayment(),
          ),
        );
      } else if (response.statusCode == 400) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        showErrorDialog(context, jsonData['message']);
          setState(() {
            _isButtonDisabled = false;
          });
      }
    } catch(e) {
      print('Error occurred while payment: $e');
    }
  }

  void getInstallments(band) async {
      try {
        double value = realToCents(totalTicketValue);
        var params = {"brand": band, "total": value};
        final url = Uri.parse(fetchInstallmentsUrl).replace(
            queryParameters: _convertMapToStrings(params));
        var response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: token,
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          dynamic data = jsonData['data'];

          List<Map<String, dynamic>> installmentsData = List.from(
              data['installments']);

          setState(() {
            installments = installmentsData;
            selectedInstallment = installmentsData[0]['installment'];
          });
        } else {
          installments = [];
        }
      } catch (e) {
        print('Error occurred while fetching installments: $e');
      }
    }
}
