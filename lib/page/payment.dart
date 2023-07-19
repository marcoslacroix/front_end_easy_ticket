import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  @override
  void initState() {
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
