// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SpeedDisplay extends StatefulWidget {
  const SpeedDisplay({Key? key}) : super(key: key);

  @override
  SpeedDisplayState createState() => SpeedDisplayState();
}

class SpeedDisplayState extends State<SpeedDisplay> {
  double velocity = 0;

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }

    setState(() {
      velocity = newVelocity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
      ),
      child: SizedBox(
        height: 80,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Text(
          '${velocity.toStringAsFixed(2)} km/h',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
