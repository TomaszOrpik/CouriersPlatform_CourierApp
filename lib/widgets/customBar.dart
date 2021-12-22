// ignore_for_file: file_names

import 'package:courier_app/widgets/directionsDisplay.dart';
import 'package:courier_app/widgets/speedDisplay.dart';
import 'package:flutter/material.dart';

class CustomBar extends StatelessWidget with PreferredSizeWidget {
  final Size prefferedSize;

  const CustomBar({Key? key})
      : prefferedSize = const Size.fromHeight(90),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: 100),
        child: SizedBox(
          height: 120,
          child: Row(
            children: const [
              DirectionsDisplay(),
              SpeedDisplay(),
            ],
          ),
        ),
      ),
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 20, top: 0),
          child: IconButton(
            icon: const Icon(
              Icons.menu,
              size: 50,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return prefferedSize;
  }
}
