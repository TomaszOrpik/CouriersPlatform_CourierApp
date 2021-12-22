// ignore_for_file: file_names

import 'package:courier_app/providers/functionality.dart';
import 'package:courier_app/providers/packages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EndButton extends StatelessWidget {
  const EndButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courierId =
        Provider.of<Functionality>(context, listen: false).courierId;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            Provider.of<Packages>(context, listen: false)
                .clearPackages(courierId);
          },
          child: const Text('Zakończ Pracę'),
        )
      ],
    );
  }
}
