
import 'package:easy_ticket/page/payment/credit_card.dart';
import 'package:easy_ticket/page/payment/personal_information.dart';
import 'package:easy_ticket/page/payment/pix.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/token_manager.dart';


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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    companyId = widget.companyId;
    eventId = widget.eventId;
    showCreditCardForm = false;
    showPersonalInformation = false;

    selectedPaymentMethod = "";

    maleTicketCountMap = widget.maleTicketCountMap;
    femaleTicketCountMap = widget.femaleTicketCountMap;
    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;
    token = TokenManager.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            TotalTickets(totalTicketValue: totalTicketValue,totalTicketCount: totalTicketCount),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
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
                      builder: (contex) => PersonalInformation(
                          totalTicketValue: totalTicketValue,
                          totalTicketCount: totalTicketCount,
                          tickets: generateTicketsObject()
                      )
                  ),
                );
              }
            },
            child: const Text("Continua"),
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
