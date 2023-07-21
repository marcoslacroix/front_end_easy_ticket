import 'dart:async';
import 'package:flutter/material.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthBloc extends ChangeNotifier {
  final _authStatusController = StreamController<AuthStatus>.broadcast();
  Stream<AuthStatus> get authStatusStream => _authStatusController.stream;

  AuthStatus _authStatus = AuthStatus.unauthenticated;

  AuthStatus get authStatus => _authStatus;

  void updateAuthStatus(AuthStatus status) {
    _authStatus = status;
    _authStatusController.add(status);
    notifyListeners();

  }

  void checkAuthentication(String? token) {
    print("Oi");
    if (token != null && token.isNotEmpty) {
      _authStatus = AuthStatus.authenticated;
      print("authenticated");
    } else {
      _authStatus = AuthStatus.unauthenticated;
      print("unauthenticated");
    }
    notifyListeners();
  }

  void dispose() {
    _authStatusController.close();
  }
}