import 'dart:convert';
import 'dart:io';

import 'package:easy_ticket/auth/auth_bloc.dart';
import 'package:easy_ticket/page/ticket/ticket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/token_manager.dart';
import '../../util/urls.dart';
import '../../util/util_ticket.dart';
import '../user/login.dart';
import 'package:http/http.dart' as http;

class MyTickets extends StatefulWidget {
  const MyTickets({Key? key}) : super(key: key);

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  late String token;
  late SharedPreferences prefs;
  late List<dynamic> items = [];
  late Future<List<dynamic>> _future = Future.value([]);


  @override
  void initState() {
    getToken();


    super.initState();

  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token")?? "";
      print("token home: $token");
      if (token.toString().isNotEmpty) {
        _future = fetchTickets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {


    return Consumer<AuthBloc>(
      builder: (context, authBloc, _) {
        if (authBloc.authStatus == AuthStatus.authenticated) {
          return Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("Meus ingressos"),),
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
                    child: Text("Você ainda não tem nenhum ingresso."),
                  );
                } else {
                  items = snapshot.data!;
                  return RefreshIndicator(
                    onRefresh: fetchTicketsData,
                    child: Scaffold(
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final ticket = items[index];

                                return GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Ticket(ticket: ticket),
                                      ),
                                    )
                                  },
                                  child: Card(
                                    child: ListTile(
                                      title: Center(child:  Text(ticket['lot']['name'])),
                                      subtitle: Column(
                                        children: [
                                          Center(child: Text(ticket['event']['name'] ?? "")),
                                          Center(child: Text(ticket['event']['period'] ?? ""))
                                        ],
                                      ),
                                      trailing: const Icon(Icons.arrow_forward), // Add the arrow icon here
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
            ),
          );
        } else {
          return const Login(event: null, screen: Screen.myTickets, selectedIndex: 3);
        }
      },
    );
  }

  Future<void> fetchTicketsData() async {

    setState(() {
      _future = fetchTickets(); // Fetch data once and store it in _future
    });
  }

  Future<List<dynamic>> fetchTickets() async {
    try {
      final url = Uri.parse(fetchTicketsUrl);
      var response = await http.get(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token
        },
      );

      print("response: $response");
      if (response.statusCode == 200 ){
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> ticketsJsonList = jsonData['tickets'];
        print("list: $ticketsJsonList");
        return ticketsJsonList;
      } else {
        print('Failed to fetch events. Status code: ${response.statusCode}');
        return [];
      }

    } catch(e) {
      print('Error occurred while fetching events: $e');
      return [];
    }
  }

}