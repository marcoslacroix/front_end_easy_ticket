import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../util/urls.dart';
import '../home/home.dart';

class Pix extends StatefulWidget {
  final dynamic pixObject;
  final double totalTicketValue;

  const Pix({required this.pixObject, required this.totalTicketValue, Key? key})
      : super(key: key);

  @override
  State<Pix> createState() => _PixState();
}

class _PixState extends State<Pix> {
  late SharedPreferences prefs;
  late dynamic pixObject;
  late final String token;
  late double totalTicketValue;
  late Future<dynamic> _futureQrcode = Future.value();
  TextEditingController _textEditingController = TextEditingController();
  bool _isCopied = false;
  late bool success;


  @override
  void initState() {
    success = false;
    super.initState();
    getToken();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _textEditingController.text));
    setState(() {
      _isCopied = true;
    });
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      totalTicketValue = widget.totalTicketValue;
      pixObject = widget.pixObject;
      token = prefs.getString("token")!;
      _futureQrcode = generateQrcode(); // Initialize _futureQrcode with the generated Future
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
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home(selectedScreen: SelectedScreen.events)),
                  (route) => false
              ); // Navigate back to the previous screen (home page)
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
              return const Center(
                child: Text(
                    "Error para gerar o QRCODE, entre em contato com a equipe."),
              );
            } else {
              print("não deu error");
              if (success) {
                Uint8List bytes = base64Decode(snapshot?.data['message']?['imagemQrcode'].split(',')[1]);
                _textEditingController.text = snapshot?.data['message']?['qrcode'];
                return Column(
                  children: [
                    const Text("Qrcode gerado com sucesso."),
                    const Text("Válido por 5 minutos"),
                    Center(child: Image.memory(bytes)),
                    Padding(
                      padding: EdgeInsets.all(16.0),
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
                        child: Text('Valor total da compra: R\$ ${totalTicketValue.toStringAsFixed(2)}')
                    ),
                    const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Obrigado pela compra.")
                    )
                  ],
                );
              } else {
                String msgError = snapshot?.data['message'] ?? "";
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
      var params = pixObject;
      String jsonBody = json.encode(params);
      var headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: '$token'
      };
      var url = Uri.parse(fetchQrcode + "?amount=$totalTicketValue");
      var response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 201) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("true sucesss");
        setState(() {
          success = true;
        });
        return jsonData;
      } else if (response.statusCode == 400){
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("response error: $jsonData");
        return jsonData;
      }
    } catch (e) {
      print('Error occurred while fetching events: $e');
    }
  }
}
