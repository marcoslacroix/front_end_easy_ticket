
import 'package:flutter/material.dart';

import '../page/checking/checking.dart';
import '../page/checking/success_checking.dart';
import '../page/event/event.dart';
import '../page/event/success_new_event.dart';
import '../page/home/home.dart';
import '../page/payment/credit_card.dart';
import '../page/payment/success_payment.dart';
import '../page/terms/terms.dart';
import '../page/ticket/buy_tickets.dart';

void moveToHome(context, screen) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => Home(selectedScreen: screen ?? SelectedScreen.events),
    ),
        (route) => false,
  );
}

void moveToTerms(context) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Terms(),
          fullscreenDialog: false
      ),
          (route) => true
  );
}

void moveToTickets(context, event) {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => BuyTickets(event: event)
      )
  );
}

void moveToChecking(context, uuid) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (contex) => Checking(ticketUuid: uuid)
    ),
  );
}

void moveToBuyTicket(context, event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BuyTickets(
          event: event
      ),
    ),
  );
}

void moveToEvent(context, event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Event(event: event),
    ),
  );
}

void moveToSuccessCreatedEvent(context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const SuccessNewEvent(),
    ),
        (route) => false,
  );
}

void moveToSuccessPayment(context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const SuccessPayment(),
    ),
        (route) => false,
  );
}

void moveToSuccessChecking(context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => const SuccessChecking()
    ),
        (route) => false,
  );
}