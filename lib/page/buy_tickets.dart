import 'dart:convert';

import 'package:easy_ticket/page/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../util/urls.dart';

class BuyTickets extends StatefulWidget {
  final dynamic event;
  const BuyTickets({required this.event, Key? key}) : super(key: key);
  @override
  State<BuyTickets> createState() => _BuyTicketsState();
}


class _BuyTicketsState extends State<BuyTickets> {
  List<dynamic> items = [];

  @override
  void initState() {
    fetchLotsData(widget.event);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black), // Definir a cor do ícone de voltar
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final tickets = item?['tickets'] ?? [];
                final lot = item?['lot'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.red,
                    child: Column(
                      children: [
                        ListTile(
                          title: Center(child: Text('${lot?['description']}')),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tickets.length,
                          itemBuilder: (context, ticketIndex) {
                            final ticket = tickets[ticketIndex];
                            String realValue = centsToReal(ticket['price']);
                            final type = ticket['type'] ?? '';

                            return ListTile(
                              title: Center(child: Text(getTypeFormated(type))),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {

                                        },
                                        child: const Icon(Icons.remove),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () => {

                                        },
                                        child: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text('Quantity: ${ticket['quantity']} - R\$ $realValue')),
                                      Center(child: Text('Contador do Lote:')),                                    ],
                                  )

                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Payment(),
                  ),
                );
              },
              child: const Text('Contiuar'),
            ),
          ),
        ],
      ),
    );
  }

  String getTypeFormated(type) {
    String typeFormated;
    switch(type) {
      case "FEMALE":
        typeFormated = "Feminino";
        break;
      case "MALE":
        typeFormated = "Masculino";
        break;
      default:
        typeFormated = "Unisex";
    }
    return typeFormated;
  }

  String centsToReal(int cents) {
    double realValue = cents / 100.0;
    return realValue.toStringAsFixed(2);
  }

  Future<void> fetchLotsData(eventId) async {
    List<dynamic> fetchedlots = await fetchLots(eventId);
    setState(() {
      items = fetchedlots;
    });
  }

  Map<String, String> _convertMapToStrings(Map<dynamic, dynamic> map) {
    final convertedMap = <String, String>{};
    map.forEach((key, value) {
      convertedMap[key.toString()] = value.toString();
    });
    return convertedMap;
  }

  Future<List<dynamic>> fetchLots(eventId) async {
    try {
      var params = {
        "eventId": eventId
      };
      final url = Uri.parse(fetchLotsUrl).replace(queryParameters: _convertMapToStrings(params));
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> eventsJsonList = jsonData['lots'];
        return eventsJsonList;
      } else {
        print('Failed to fetch events. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error occurred while fetching events: $e');
      return [];
    }
  }
}
