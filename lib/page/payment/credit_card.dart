import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/payment/success_payment.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';


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
  late TextEditingController _expirationPeriodController;
  late final _cardNumberFocus;
  late final _cvvFocus;
  late final _expirationPeriodFocus;

  late bool _showCardInformation;
  late String? selectedBandType;
  late final double totalTicketValue;
  late final int totalTicketCount;
  late String token;

  late dynamic installments;
  late int selectedInstallment;
  late bool _isButtonDisabled;
  late bool _isLoading;

  var maskFormatterPeriod = MaskTextInputFormatter(
      mask: '##/##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _isButtonDisabled = false;
    _isLoading = true;
    selectedInstallment = 1;
    installments = [];
    _showCardInformation = false;
    _cardNumberController = TextEditingController();
    _cvvController = TextEditingController();
    _expirationPeriodController = TextEditingController();

    _cardNumberFocus = FocusNode();
    _cvvFocus = FocusNode();
    _expirationPeriodFocus = FocusNode();

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
                              _showCardInformation = true;
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
                              _showCardInformation = true;
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
                              _showCardInformation = true;
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
                              _showCardInformation = true;
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
                              _showCardInformation = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                if (_showCardInformation)
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
                            maxLength: 4,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Código de segurança (CVV) é obrigatório.";
                              }
                            },
                          ),
                          TextFormField(
                              controller: _expirationPeriodController,
                              decoration: const InputDecoration(labelText: "Período (MM/YY)"),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [maskFormatterPeriod],
                              focusNode: _expirationPeriodFocus,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Período é obrigatório.';
                                }
                                if (value.length < 5) {
                                  return "Período inválido.";
                                }

                                print("value: $value");
                                if (value.length > 1) {
                                  String month = value.substring(0, 2);
                                  int? monthInt = int.tryParse(month);
                                  if (monthInt == null || monthInt < 1 || monthInt > 12) {
                                    return 'Mês inválido (1 a 12)';
                                  }
                                }

                                if(value.length > 3) {
                                  String year = value.substring(3, 5);

                                  int? yearInt = int.tryParse(year);
                                  int currentYear = DateTime.now().year;
                                  int currentYearReplace = int.parse(currentYear.toString().replaceRange(0, 2, ""));
                                   if (yearInt! < currentYearReplace) {
                                    return "O seu cartão está vencido.";
                                  } else if (yearInt > 99) {
                                    return 'Ano inválido (00 to 99)';
                                  }
                                }
                                return null;
                              }
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
                          if (_isLoading) // Show the loading indicator
                            const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                TotalTickets(totalTicketValue: totalTicketValue, totalTicketCount: totalTicketCount)
              ],
            ),
          ),

          bottomNavigationBar: BottomAppBar(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonDisabled
                    ? null
                    : _isLoading ? null : _onConfirmPayment,
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
      await requestPayment(context);
    }
  }

  dynamic getBodyPayment() {
    var body = {
      "company": widget.tickets['company'],
      "event": widget.tickets['event'],
      "tickets": widget.tickets['tickets'],
      "card": {
        "brand": selectedBandType,
        "number": _cardNumberController.text,
        "cvv": _cvvController.text,
        "expiration_month": _expirationPeriodController.text.substring(0,2),
        "expiration_year": _expirationPeriodController.text.substring(3,5),
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
          title: const Text('Erro no pagamento'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
        setState(() {
          _isButtonDisabled = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessPayment(),
          ),
          (route) => false,
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
        setState(() {
          installments = [];
          _isLoading = true;
        });

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
            _isLoading = false;
          });
        } else {
          installments = [];
        }
      } catch (e) {
        print('Error occurred while fetching installments: $e');
      }
    }
}
