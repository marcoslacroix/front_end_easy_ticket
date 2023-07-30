import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enum/user_role.dart';

class AuthProvider extends ChangeNotifier {
  List<UserRole> _roles = [];

  List<UserRole> get roles => _roles;

  void updateRoles(List<UserRole> newRoles) {
    _roles = newRoles;
    notifyListeners();
  }

  void removeAllRoles() {
    _roles = [];
    notifyListeners();
  }

  void addRole(UserRole newRole) {
    if (!_roles.contains(newRole)) {
      _roles.add(newRole);
      notifyListeners();
    }
  }

  void removeRole(UserRole roleToRemove) {
    _roles.remove(roleToRemove);
    notifyListeners();
  }

}
