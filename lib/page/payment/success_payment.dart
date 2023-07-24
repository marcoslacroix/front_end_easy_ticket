import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home(selectedScreen: SelectedScreen.events)),
                      (route) => false
              ); // Navigate back to the previous screen (home page)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Text("Pagamento aprovado.")
        ],
      ),
    );
  }
}
