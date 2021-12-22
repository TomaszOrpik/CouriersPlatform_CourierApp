// ignore_for_file: file_names
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:courier_app/providers/directions.dart';

class DirectionsDisplay extends StatelessWidget {
  const DirectionsDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final directions = Provider.of<Directions>(context).directions;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: SizedBox(
        height: 110,
        width: MediaQuery.of(context).size.width * 0.50,
        child: Column(
          children: [
            if (directions[0].modifier == 'straight')
              const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 75,
              ),
            if (directions[0].modifier == 'left')
              const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 75,
              ),
            if (directions[0].modifier == 'right')
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 75,
              ),
            if (directions[0].modifier == 'slight left')
              Transform.rotate(
                angle: -45 * math.pi / -45,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 75,
                ),
              ),
            if (directions[0].modifier == 'slight right')
              Transform.rotate(
                angle: 45 * math.pi / 45,
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 75,
                ),
              ),
            if (directions[0].type == 'arrive')
              const Text(
                'Miejsce Docelowe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (directions[0].type != 'arrive')
              Text(
                'za ${directions[0].distance.toStringAsFixed(0)}m',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
