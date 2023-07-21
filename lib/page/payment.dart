import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Payment extends StatefulWidget {
  final dynamic maleTicketCountMap;
  final dynamic femaleTicketCountMap;
  const Payment({Key? key, required this.maleTicketCountMap, required this.femaleTicketCountMap}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  late final dynamic maleTicketCountMap;
  late final dynamic femaleTicketCountMap;
  @override
  void initState() {
    setState(() {
      maleTicketCountMap = widget.maleTicketCountMap;
      femaleTicketCountMap = widget.femaleTicketCountMap;
      print("maleTicketCountMap: $maleTicketCountMap");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
          elevation: 0,
        ),
        body: const Text("Test"),

    );
  }
}
