
import 'package:flutter/material.dart';

import '../page/home/home.dart';
import '../page/ticket/buy_tickets.dart';

void moveToHome(context, screen, fullSceen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Home(selectedScreen: screen ?? SelectedScreen.events),
      fullscreenDialog: fullSceen,
    ),
        (route) => false,
  );
}


void moveToTickets(context, event) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => BuyTickets(event: event)
      )
  );
}