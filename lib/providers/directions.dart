import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:courier_app/constants.dart';
import 'package:courier_app/models/direction.dart';
import 'package:courier_app/models/packageDistance.dart';
import 'package:courier_app/models/position.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagesDirectionsResponse {
  List<PackageDistance> packageDistance;
  List<Direction> directions;

  factory PackagesDirectionsResponse.fromJson(
      Map<String, dynamic> responseBody) {
    List<PackageDistance> packageDistance = [];
    List<Direction> directions = [];
    List<dynamic> packageDistanceData = responseBody['packagesDistance'];
    List<dynamic> directionsData = responseBody['directions'];
    for (var data in packageDistanceData) {
      packageDistance.add(PackageDistance(
        distance: data['distance'],
        time: data['time'],
        packageId: data['packageId'],
      ));
    }
    for (var data in directionsData) {
      directions.add(
        Direction(
          distance: data['distance'],
          duration: data['duration'],
          modifier:
              data['modifier'].toString() != 'null' ? data['modifier'] : '',
          type: data['type'],
          name: data['name'],
        ),
      );
    }
    return PackagesDirectionsResponse(
      packageDistance: packageDistance,
      directions: directions,
    );
  }

  PackagesDirectionsResponse({
    required this.packageDistance,
    required this.directions,
  });
}

class Directions with ChangeNotifier {
  List<Direction> _directions = [];
  List<PackageDistance> _packageDistance = [];

  List<Direction> get directions {
    return _directions;
  }

  List<PackageDistance> get packageDistance {
    return _packageDistance;
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

  Future<void> setPackagesForCourier(String courierId) async {
    final headers = await this.headers;
    final url =
        Uri.parse('${CONSTANTS.apiEndpoint}couriers/set-packages/$courierId');
    final response = await http.post(url, headers: headers);
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final packagesDirectionsResponse =
        PackagesDirectionsResponse.fromJson(responseBody);

    _packageDistance = packagesDirectionsResponse.packageDistance;
    _directions = packagesDirectionsResponse.directions;
    notifyListeners();
  }

  Future<void> updatePosition(Position position, String courierId) async {
    final headers = await this.headers;

    final url =
        Uri.parse('${CONSTANTS.apiEndpoint}couriers/position/$courierId');
    final response = await http.post(url,
        body: {
          "longitude": position.longitude.toString(),
          "latitude": position.latitude.toString()
        },
        headers: headers);
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final packageDirectionsResponse =
        PackagesDirectionsResponse.fromJson(responseBody);

    _packageDistance = packageDirectionsResponse.packageDistance;
    _directions = packageDirectionsResponse.directions;
    notifyListeners();
  }
}
