import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/util_routes.dart';
import '../home/home.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({Key? key}) : super(key: key);

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Status do pagamento")),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              moveToHome(context, SelectedScreen.events);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/approved.png',
                    width: 64,
                    height: 64,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Pagamento aprovado.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Após aprovação, em até uma hora seu ingresso estará disponível.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Obrigado pela compra.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
