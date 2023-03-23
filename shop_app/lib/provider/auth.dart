import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/httpexception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> signup(
      String email, String password, String requesttoken) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$requesttoken?key=AIzaSyDFP3ehloFiVsAfAHhGC9WdqiCjXuaRRDM');

    try {
      final response = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );

      final data = json.decode(response.body);
      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _expireDate =
          DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
      _userId = data['localId'];
      final pref = await SharedPreferences.getInstance();
      final d = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expireDate.toIso8601String(),
      });
      autoLogout();
      notifyListeners();

      pref.setString('userData', d);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _token = null;
    _expireDate = null;
    _userId = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeLeft = _expireDate.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeLeft), logout);
  }

  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    final expireDate = DateTime.parse(userData['expiryDate']);

    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    _expireDate = expireDate;
    _token = userData['token'];
    _userId = userData['userId'];
    notifyListeners();
    autoLogout();
    return true;
  }
}
