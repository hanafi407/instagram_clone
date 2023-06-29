import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import '../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUser();

    _user = user;
    notifyListeners();
  }
}
