
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/checking/success_checking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


import '../../auth/token_manager.dart';
import '../../util/urls.dart';
import '../../util/util_http.dart';
import '../../util/util_routes.dart';
import '../../util/util_ticket.dart';

class Checking extends StatefulWidget {
  final String ticketUuid;
  const Checking({
    required this.ticketUuid,
    Key? key
  }) : super(key: key);

  @override
  State<Checking> createState() => _CheckingState();
}

class _CheckingState extends State<Checking> {

  late final String token;
  late bool success;
  late bool isButtonDisabled = true;
  late Future<dynamic> _futureTicket = Future.value();
  late int eventId;

  @override
  void initState() {
    super.initState();
    token = TokenManager.instance.getToken();
    if (token != null && token.toString().isNotEmpty) {
      _futureTicket = fetchTicket(token, widget.ticketUuid);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Checking")),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
        ),
        body: FutureBuilder<dynamic>(
          future: _futureTicket,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Ingresso inválido",
                    style: TextStyle(color: Colors.red), // Change the error message text color
                  ),
                ),
              );
            } else {
              String? error = snapshot.data['error'];
              if (error != null && error.isNotEmpty) {
                return Center(child: Text(error));
              } else {
                String type = getTypeFormated(snapshot.data['ticket']['type']);
                return Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 400.0),
                        child: Text("Evento: ${snapshot.data['event']['name']}"),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Ingresso: ${snapshot.data['lot']['description']} ",
                              style: const TextStyle(color: Colors.black), // Default color for the text
                            ),
                            TextSpan(
                              text: type,
                              style: TextStyle(color: snapshot.data['ticket']['type'] == "MALE" ? Colors.blue : Colors.pink),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
          }

        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => {
                isButtonDisabled ? null : _confirmChecking(context)
              },
              child: const Text('Confirmar checking')
            ),
          ),
        ),


    );
  }

  Future<dynamic> fetchTicket(token, uuid) async {
    try {

      var params = {"uuid": uuid};
      final url = Uri.parse(fetchTicketByUuid)
          .replace(queryParameters: convertMapToStrings(params));
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        print(jsonData);
        setState(() {
          isButtonDisabled = false;
          eventId = jsonData['event']['id'];
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



  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro no checking'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmChecking(context) async {
    setState(() {
      isButtonDisabled = true;
    });
    try {
      var body = {
        "uuid": widget.ticketUuid,
        "event": eventId
      };
      String jsonBody = json.encode(body);

      var url = Uri.parse(ticketChecking);
      var response = await http.post(
          url,
          body: jsonBody,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: token,
          },
      );

      setState(() {
        isButtonDisabled = false;
      });

      if (response.statusCode == 204) {
        moveToSuccessChecking(context);
      } else if (response.statusCode == 400){
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        showErrorDialog(context, jsonData['error']);
      }
    } catch (e) {
      print('Error occurred while checking tickket: $e');
    }
  }

}
