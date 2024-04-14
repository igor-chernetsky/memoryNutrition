import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final String playground;
  const Separator({super.key, this.playground = 'wood'});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.0,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/$playground/top-border.png'),
              fit: BoxFit.fill)),
    );
  }
}
