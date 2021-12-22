import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:courier_app/models/package.dart';
import 'package:courier_app/models/position.dart';
import 'package:courier_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class PackagesResponse {
  List<Package> packages;

  PackagesResponse(this.packages);

  factory PackagesResponse.fromJson(List<dynamic> responseBody) {
    List<Package> packages = [];
    for (var data in responseBody) {
      final Map<String, dynamic> sender = data['sender'];
      final Map<String, dynamic> receiver = data['receiver'];
      final Map<String, dynamic> position = data['position'];
      final package = Package(
        id: data['id'],
        comments: data['comments'],
        packageNumber: data['packageNumber'],
        receiver: User(
          id: receiver['id'],
          firstName: receiver['firstName'],
          lastName: receiver['lastName'],
          street: receiver['street'],
          postCode: receiver['postCode'],
          city: receiver['city'],
          phoneNumber: receiver['phoneNumber'],
        ),
        sender: User(
          id: sender['id'],
          firstName: sender['firstName'],
          lastName: sender['lastName'],
          street: sender['street'],
          postCode: sender['postCode'],
          city: sender['city'],
          phoneNumber: sender['phoneNumber'],
        ),
        sendDate: data['sendDate'],
        position: Position(
            latitude: position['latitude'], longitude: position['longitude']),
        status: data['status'],
      );
      packages.add(package);
    }
    return PackagesResponse(packages);
  }
}

class Packages with ChangeNotifier {
  List<Package> _packages = [];

  List<Package> get packages {
    return _packages;
  }

  Future<Map<String, String>> get headers async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('userToken');
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": token ?? '',
    };
  }

  Future<void> getPackages(String courierId) async {
    final headers = await this.headers;

    final url =
        Uri.parse('${CONSTANTS.apiEndpoint}couriers/get-packages/$courierId');
    final response = await http.get(url, headers: headers);
    final List<dynamic> responseBody = json.decode(response.body);
    final packages = PackagesResponse.fromJson(responseBody).packages;
    _packages = packages;
    notifyListeners();
  }

  Future<void> updatePackage(
      String courierId, String packageId, bool isDelivered) async {
    final headers = await this.headers;

    final url =
        Uri.parse('${CONSTANTS.apiEndpoint}couriers/update-package/$courierId');
    final body = {
      'packageId': packageId,
      'isDelivered': isDelivered.toString()
    };
    final response = await http.post(url, body: body, headers: headers);
    final List<dynamic> responseBody = json.decode(response.body);
    final packages = PackagesResponse.fromJson(responseBody).packages;
    _packages = packages;
    notifyListeners();
  }

  Future<bool> clearPackages(String courierId) async {
    final headers = await this.headers;

    final url =
        Uri.parse('${CONSTANTS.apiEndpoint}couriers/clear-packages/$courierId');
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 202) {
      _packages.clear();
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
