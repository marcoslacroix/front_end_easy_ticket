import 'dart:convert';

import 'package:easy_ticket/page/event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
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
    fetchEventsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return GestureDetector(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Event(event: event),
                      ),
                    )
                  },
                  child: Card(
                    color: Colors.red,

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
    );
  }

  Future<void> fetchEventsData() async {

    List<dynamic> fetchedEvents = await fetchEvents();
    setState(() {
      events = fetchedEvents;
    });
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<List<dynamic>> fetchEvents({int page = 1, int pageSize = 10}) async {
    try {
      var url = Uri.parse('$fetchEventsUrl?page=$page&pageSize=$pageSize');
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
