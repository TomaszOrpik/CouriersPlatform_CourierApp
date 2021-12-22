import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:courier_app/constants.dart';

class LoginData {
  final String login;
  final String password;

  LoginData({required this.login, required this.password});
}

class Tokens {
  final String userToken;
  final String mapToken;

  Tokens({required this.userToken, required this.mapToken});
}

class LoginDataResponseModel {
  final bool isLoginCorrect;
  final Tokens tokens;

  LoginDataResponseModel({
    required this.isLoginCorrect,
    required this.tokens,
  });
}

class LoginDataResponse {
  LoginDataResponseModel response;

  LoginDataResponse(this.response);

  factory LoginDataResponse.fromJson(Map<String, dynamic> responseBody) {
    final bool isLoginCorrect = responseBody['isLoginCorrect'];
    final Map<String, dynamic> tokens = responseBody['tokens'];
    final String userToken = tokens['userToken'];
    final String mapToken = tokens['mapToken'];

    final LoginDataResponseModel responseModel = LoginDataResponseModel(
      isLoginCorrect: isLoginCorrect,
      tokens: Tokens(
        mapToken: mapToken,
        userToken: userToken,
      ),
    );
    return LoginDataResponse(responseModel);
  }
}

class Functionality with ChangeNotifier {
  bool _isLogged = false;
  String _courierId = '';

  bool get isLogged {
    return _isLogged;
  }

  String get courierId {
    return _courierId;
  }

  Future<String> get mapToken async {
    final prefs = await SharedPreferences.getInstance();
    final String? mapToken = prefs.getString('mapToken');
    return mapToken ?? '';
  }

  Future<bool> logIn(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('${CONSTANTS.apiEndpoint}couriers/login');
    final response = await http
        .post(url, body: {'login': data.login, 'password': data.password});
    final responseBody = json.decode(response.body);
    final responseModel = LoginDataResponse.fromJson(responseBody);
    _isLogged = responseModel.response.isLoginCorrect;
    _courierId = data.login;

    prefs.setString('userToken', responseModel.response.tokens.userToken);
    prefs.setString('mapToken', responseModel.response.tokens.mapToken);

    notifyListeners();
    return _isLogged;
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogged = false;
    _courierId = '';

    prefs.clear();

    notifyListeners();
  }
}
