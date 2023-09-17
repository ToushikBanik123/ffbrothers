import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../Model/UserModel.dart';
import 'package:http/http.dart' as http;

class AppProvider with ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;
  void setUser(UserModel? value) {
    _user = value;
    notifyListeners();
  }
}