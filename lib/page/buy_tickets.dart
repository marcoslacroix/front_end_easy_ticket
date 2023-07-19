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
  Map<int, int> maleTicketCountMap = {};
  Map<int, int> femaleTicketCountMap = {};
  int totalTicketCount = 0;
  double totalTicketValue = 0.0;
  var enableContinue = false;

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
        iconTheme: const IconThemeData(color: Colors.black),
        // Definir a cor do ícone de voltar
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: tickets.length,
                        itemBuilder: (context, ticketIndex) {
                          final ticket = tickets[ticketIndex];
                          String realValue = centsToReal(ticket['price']);
                          final type = ticket['type'] ?? '';
                          final description = lot['description'];
                          final lotId = lot['id'];

                          // Initialize ticket counts for each lot
                          maleTicketCountMap[lotId] ??= 0;
                          femaleTicketCountMap[lotId] ??= 0;

                          return ListTile(
                            title: Center(child: Text(description + " " + getTypeFormated(type))),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (type == 'MALE' && maleTicketCountMap[lotId]! > 0) {
                                            maleTicketCountMap[lotId] = maleTicketCountMap[lotId]! - 1;
                                            totalTicketCount--;
                                            totalTicketValue -= ticket['price'] / 100.0;

                                            if (maleTicketCountMap[lotId]! == 0) {
                                              enableContinue = false;
                                            }
                                          } else if (type == 'FEMALE' && femaleTicketCountMap[lotId]! > 0) {
                                            femaleTicketCountMap[lotId] = femaleTicketCountMap[lotId]! - 1;
                                            totalTicketCount--;
                                            totalTicketValue -= ticket['price'] / 100.0;

                                            if (maleTicketCountMap[lotId]! == 0) {
                                              enableContinue = false;
                                            }
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.remove),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      type == 'MALE' ? '${maleTicketCountMap[lotId]}' : '${femaleTicketCountMap[lotId]}',
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (isTicketAvailable(type, lotId)) {
                                            if (type == 'MALE') {
                                              maleTicketCountMap[lotId] = maleTicketCountMap[lotId]! + 1;
                                              totalTicketCount++;
                                              totalTicketValue += ticket['price'] / 100.0;

                                              if (maleTicketCountMap[lotId]! > 0) {
                                                enableContinue = true;
                                              }
                                            } else if (type == 'FEMALE') {
                                              femaleTicketCountMap[lotId] = femaleTicketCountMap[lotId]! + 1;
                                              totalTicketCount++;
                                              totalTicketValue += ticket['price'] / 100.0;

                                              if (femaleTicketCountMap[lotId]! > 0) {
                                                enableContinue = true;
                                              }
                                            }
                                          } else {
                                            // Ticket not available, show an error message or handle it as needed
                                            // For example, you can use a Snackbar to show an error message:
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('No more tickets available for this type and lot.'),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: Text(
                                            'R\$ $realValue')),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        },
                      ),
                    ));
              },
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
              onPressed: () {
                print("anableContinue $enableContinue");
                enableContinue ?
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Payment(),
                  ),
                )
                : null;
              },
              child: const Text('Contiuar'),
            ),
          ),
        ],
      ),
    );
  }

  bool isTicketAvailable(String type, int lotId) {
    final lot = items.firstWhere((item) => item['lot']['id'] == lotId, orElse: () => null);
    if (lot == null) {
      return false;
    }

    final tickets = lot['tickets'];
    if (type == 'MALE') {
      return maleTicketCountMap[lotId]! < tickets[1]['quantity'];
    } else if (type == 'FEMALE') {
      return femaleTicketCountMap[lotId]! < tickets[0]['quantity'];
    }
    return false;
  }

  String getTypeFormated(type) {
    String typeFormated;
    switch (type) {
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
      var params = {"eventId": eventId};
      final url = Uri.parse(fetchLotsUrl)
          .replace(queryParameters: _convertMapToStrings(params));
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
