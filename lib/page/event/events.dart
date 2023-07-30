import 'dart:convert';

import 'package:easy_ticket/page/event/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import '../../util/urls.dart';
import '../../util/util_data.dart';
import '../../util/util_routes.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}
class _EventsState extends State<Events> {
  List<dynamic> events = [];
  late Future<List<dynamic>> _future = Future.value([]); // Initialize with an empty list

  @override
  void initState() {
    fetchEventsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Eventos")),
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
              child: Text("Erro na busca dos eventos"),
            );
          }  else if (snapshot == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhum evento disponível"),
            );
          } else {
            events = snapshot.data!;
            return RefreshIndicator(
              onRefresh: fetchEventsData,
              child: Scaffold(
                body: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            final event = events[index];

                            return GestureDetector(
                              onTap: () => {
                                moveToEvent(context, event)
                              },
                              child: Card(
                                child: ListTile(
                                  title: Text(event['name'] ?? ''),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                          children: [
                                            Text(event?['id'].toString() ?? '')
                                          ]
                                      ),
                                      Row(
                                          children: [
                                            Text(formatDate(event?['period']) ?? '')
                                          ]
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },

      ),
    );
  }

  Future<void> fetchEventsData() async {

    setState(() {
      _future = fetchEvents(); // Fetch data once and store it in _future
    });
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
