import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../auth/token_manager.dart';
import '../../util/util_data.dart';
import '../../util/util_ticket.dart' as util_ticket;

class Ticket extends StatefulWidget {
  final dynamic ticket;
  const Ticket({Key? key, required this.ticket}) : super(key: key);

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  late String token;
  late Future<String> _future;
  bool _isCopied = false;

  late TextEditingController _textEditingController;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    token = TokenManager.instance.getToken();
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.ticket["uuid"];
    if (token != null && token.toString().isNotEmpty) {
      _future = util_ticket.fetchTicketQrcode(widget.ticket["uuid"], token);
    }
    super.initState();
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
      appBar: AppBar(
        title: const Center(child: Text("Ingresso")),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar o QR Code'));
          } else {
            Uint8List bytes = base64Decode(snapshot.data.split(',')[1]);
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(child: Text(widget.ticket["lot"]['name'])),
                        Center(child: Text(widget.ticket["event"]['name'])),
                        Center(child: Text(formatDate(widget.ticket["event"]['period']))),
                        Center(child: Text(widget.ticket["event"]['start'])),
                        const SizedBox(height: 20),
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text("Apresente o QR Code ou informe o código para entrar no evento"),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}