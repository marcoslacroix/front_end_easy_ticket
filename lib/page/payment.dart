import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Payment extends StatefulWidget {
  final dynamic maleTicketCountMap;
  final dynamic femaleTicketCountMap;
  final int totalTicketCount;
  final double totalTicketValue;

  const Payment({
    Key? key,
    required this.maleTicketCountMap,
    required this.femaleTicketCountMap,
    required this.totalTicketCount,
    required this.totalTicketValue,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final dynamic maleTicketCountMap;
  late final dynamic femaleTicketCountMap;
  late final double totalTicketValue;
  late final int totalTicketCount;
  late String? selectedPaymentMethod;
  bool showCreditCardForm = false;
  TextEditingController dateInputController = TextEditingController();
  late String birthDate;

  @override
  void initState() {
    super.initState();
    selectedPaymentMethod = "";
    birthDate = "";
    dateInputController.text = ""; // Set the initial value of the text field
    maleTicketCountMap = widget.maleTicketCountMap;
    femaleTicketCountMap = widget.femaleTicketCountMap;
    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // Existing code...
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
                      });
                    },
                  ),
                ],
              ),
            ),
            if (showCreditCardForm)
              Card(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Nome do titular"),
                      keyboardType: TextInputType.text,
                      // Add appropriate controller, validator, etc.
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      // Add appropriate controller, validator, etc.
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "CPF"),
                      keyboardType: TextInputType.number,
                      // Add appropriate controller, validator, etc.
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Telefone"),
                      keyboardType: TextInputType.number,
                      // Add appropriate controller, validator, etc.
                    ),
                    TextField(
                      controller: dateInputController,
                      // Editing controller of this TextField
                      decoration: InputDecoration(labelText: "Data de nascimento"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2101),// Set the locale to Brazilian Portuguese
                        );

                        if (pickedDate != null) {
                          print(pickedDate); // Picked date output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          String formattedDateYYYYmmDD = DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(formattedDate); // Formatted date output => 16-03-2021
                          // You can implement different kinds of date format here according to your requirement

                          setState(() {
                            birthDate = formattedDateYYYYmmDD;
                            print("birthDate $birthDate");
                            dateInputController.text = formattedDate; // Set output date to TextField value.
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text('Total de ingressos selecionados: $totalTicketCount'),
                  Text('Valor total: R\$ ${totalTicketValue.toStringAsFixed(2)}'),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Continua"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
