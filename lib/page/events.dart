import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

import '../util/urls.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    fetchEventsData();
  }

  Future<void> fetchEventsData() async {
    // Aqui você pode chamar o método fetchEvents() para buscar os eventos
    // e atualizar a lista de eventos
    List<dynamic> fetchedEvents = await fetchEvents();

    setState(() {
      events = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 350.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "EVENTOS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: kIsWeb ? Axis.vertical : Axis.horizontal,
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Row(
                    children: [
                      SizedBox(
                        width: 250,
                        child: InkWell(
                          onTap: () {
                            print("oi");
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          event['name'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          event['description'],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<List<dynamic>> fetchEvents() async {
    try {
      var url = Uri.parse(fetchEventsUrl);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> eventsJsonList = jsonData['events'];
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
