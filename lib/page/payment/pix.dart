import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../auth/token_manager.dart';
import '../../util/urls.dart';
import '../../util/util_routes.dart';
import '../home/home.dart';

class Pix extends StatefulWidget {
  final dynamic tickets;
  final double totalTicketValue;

  const Pix({required this.tickets, required this.totalTicketValue, Key? key})
      : super(key: key);

  @override
  State<Pix> createState() => _PixState();
}

class _PixState extends State<Pix> {
  late SharedPreferences prefs;
  late dynamic tickets;
  late final String token;
  late double totalTicketValue;
  late Future<dynamic> _futureQrcode = Future.value();
  final TextEditingController _textEditingController = TextEditingController();
  bool _isCopied = false;
  late bool success;


  @override
  void initState() {
    success = false;
    super.initState();
    token = TokenManager.instance.getToken();
    totalTicketValue = widget.totalTicketValue;
    tickets = widget.tickets;
    _futureQrcode = generateQrcode();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textEditingController.text));
    setState(() {
      _isCopied = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Center(child: Text("Qr code")),
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              moveToHome(context, SelectedScreen.events);
            },
          ),
        ],
        // Existing code...
      ),
      body: FutureBuilder<dynamic>(
          future: _futureQrcode,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const  Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Error para gerar o QRCODE, entre em contato com a equipe.",
                    style: TextStyle(color: Colors.red), // Change the error message text color
                  ),
                ),
              );
            } else {
              if (success) {
                Uint8List bytes = base64Decode(snapshot.data['message']?['imagemQrcode'].split(',')[1]);
                _textEditingController.text = snapshot.data['message']?['qrcode'];
                return Column(
                  children: [
                    const Text(
                      "Qrcode gerado com sucesso.",
                      style: TextStyle(
                        fontFamily: 'Roboto', // Change the font family
                        fontSize: 20.0, // Change the font size
                        fontWeight: FontWeight.bold, // Change the font weight
                        color: Colors.black, // Change the text color
                      ),
                    ),
                    const Text("Válido por 5 minutos"),
                    Center(child: Image.memory(bytes)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _textEditingController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Código QR",
                          suffixIcon: _isCopied
                              ? const Icon(Icons.check, color: Colors.green)
                              : IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                _copyToClipboard();
                              }),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Valor total da compra: ${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(totalTicketValue)}'),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Obrigado pela compra.",
                        style: TextStyle(
                          fontStyle: FontStyle.italic, // Change the font style
                          color: Colors.grey, // Change the text color
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                String msgError = snapshot.data['error'] ?? "";
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(msgError),
                  ),
                );
              }

            }
          }),
    );
  }

  Future<dynamic> fetchQRCODE() async {
    return await generateQrcode();
  }

  Future<dynamic> generateQrcode() async {
    try {
      var params = tickets;
      String jsonBody = json.encode(params);
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: '$token'
      };
      var url = Uri.parse("$fetchQrcode?amount=$totalTicketValue");
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          success = true;
        });
        return jsonData;
      } else if (response.statusCode == 400){
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        return jsonData;
      }
    } catch (e) {
      print('Error occurred while fetching events: $e');
    }
  }
}
