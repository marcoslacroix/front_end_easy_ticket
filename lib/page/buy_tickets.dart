import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/page/payment/payment.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_bloc.dart';
import '../auth/token_manager.dart';
import '../util/urls.dart';
import 'login.dart';

class BuyTickets extends StatefulWidget {
  final dynamic event;
  const BuyTickets({
    required this.event,
    Key? key
  }) : super(key: key);

  @override
  State<BuyTickets> createState() => _BuyTicketsState();
}

class _BuyTicketsState extends State<BuyTickets> {
  late List<dynamic> items = [];
  late Map<int, int> maleTicketCountMap = {};
  late Map<int, int> femaleTicketCountMap = {};
  late int totalTicketCount;
  late double totalTicketValue;
  var enableContinue = false;
  late var quantityTicketsUserAlreadyBougthForThisEvent;
  late String token;
  late int eventId;
  late dynamic event;
  late int companyId;
  late Future<List<dynamic>> _future = Future.value([]); // Initialize with an empty list

  @override
  void initState() {
    totalTicketValue = 0;
    totalTicketCount = 0;
    setState(() {
      var ev = widget.event;
      event = ev;
      eventId = ev?['id'];
      companyId = ev?['companyId'];
      token = TokenManager.instance.getToken();
      if (token != null && token.toString().isNotEmpty) {
        _future = fetchLots(eventId);
      }
    });
    super.initState();
  }

  void updateTotalTickets(int count, double value) {
    setState(() {
      totalTicketCount = count;
      totalTicketValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        if (authBloc.authStatus == AuthStatus.authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("Ingressos")),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: FutureBuilder<List<dynamic>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error fetching data"),
                  );
                } else if (snapshot == null || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("Nenhum ingresso disponível"),
                  );
                } else {
                  items = snapshot.data!;
                  return Column(
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
                                      double realValue = centsToReal(ticket['price']);
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
                                                        totalTicketValue -= ticket['price'] / 100;
                                                        updateTotalTickets(totalTicketCount, totalTicketValue);

                                                        if (maleTicketCountMap[lotId]! == 0) {
                                                          enableContinue = false;
                                                        }
                                                      } else if (type == 'FEMALE' && femaleTicketCountMap[lotId]! > 0) {
                                                        femaleTicketCountMap[lotId] = femaleTicketCountMap[lotId]! - 1;
                                                        totalTicketCount--;
                                                        totalTicketValue -= ticket['price'] / 100;
                                                        updateTotalTickets(totalTicketCount, totalTicketValue);


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
                                                    bool canBuyTickets = quantityTicketsUserAlreadyBougthForThisEvent + totalTicketCount < 5;
                                                    canBuyTickets ?
                                                    setState(() {
                                                      if (isTicketAvailable(type, lotId)) {
                                                        if (type == 'MALE') {
                                                          maleTicketCountMap[lotId] = maleTicketCountMap[lotId]! + 1;
                                                          totalTicketCount++;
                                                          totalTicketValue += ticket['price'] / 100.0;
                                                          updateTotalTickets(totalTicketCount, totalTicketValue);

                                                          if (maleTicketCountMap[lotId]! > 0) {
                                                            enableContinue = true;
                                                          }
                                                        } else if (type == 'FEMALE') {
                                                          femaleTicketCountMap[lotId] = femaleTicketCountMap[lotId]! + 1;
                                                          totalTicketCount++;
                                                          totalTicketValue += ticket['price'] / 100.0;
                                                          updateTotalTickets(totalTicketCount, totalTicketValue);

                                                          if (femaleTicketCountMap[lotId]! > 0) {
                                                            enableContinue = true;
                                                          }
                                                        }
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Não há mais ingressos disponíveis para este tipo e lote.'),
                                                            behavior: SnackBarBehavior.floating,
                                                          ),
                                                        );
                                                      }
                                                    })
                                                        : ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text('Quantidade máxima de ingressos por usuário atingido.'),
                                                        behavior: SnackBarBehavior.floating,
                                                      ),
                                                    );
                                                  },
                                                  child: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                    child: Text('${NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(realValue)}')),
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
                      TotalTickets(
                          totalTicketCount: totalTicketCount, totalTicketValue: totalTicketValue
                      ),

                    ],
                  );
                }
              }
            ),
            bottomNavigationBar: BottomAppBar(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    enableContinue ?
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment(
                          maleTicketCountMap: maleTicketCountMap,
                          femaleTicketCountMap: femaleTicketCountMap,
                          totalTicketCount: totalTicketCount,
                          totalTicketValue: totalTicketValue,
                          companyId: companyId,
                          eventId: eventId,
                        ),
                      ),
                    )
                        : null;
                  },
                  child: const Text('Contiuar'),
                ),
              ),
            ),
          );
        } else {
          if (event != null) {
            return Login(event: event, screen: Screen.buyTickets, selectedIndex: 0);
          } else {
            return Container();
          }
        }
      },
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

  double centsToReal(int cents) {
    return cents / 100.0;
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
      var response = await http.get(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: token
          },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> eventsJsonList = jsonData['lots'];
        setState(() {
          quantityTicketsUserAlreadyBougthForThisEvent = jsonData['quantityTicketsUserAlreadyBougthForThisEvent'];
        });
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
