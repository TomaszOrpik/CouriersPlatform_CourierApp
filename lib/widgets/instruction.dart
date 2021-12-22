import 'package:flutter/material.dart';

class Instruction extends StatelessWidget {
  final String title;
  final String image;

  const Instruction(this.title, this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Image(
            image: AssetImage(image),
          ),
        ),
      ],
    );
  }
}
