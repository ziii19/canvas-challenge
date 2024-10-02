import 'package:flutter/material.dart';

class FractionWidget extends StatelessWidget {
  final int numerator;
  final int denominator;

  const FractionWidget({
    super.key,
    required this.numerator,
    required this.denominator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$numerator',
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
        const Divider(
          color: Colors.white,
          thickness: 2,
          indent: 20,
          endIndent: 20,
        ),
        Text(
          '$denominator',
          style: const TextStyle(color: Colors.white, fontSize: 40),
        ),
      ],
    );
  }
}
