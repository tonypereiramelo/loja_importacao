import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CorLoading extends StatelessWidget {
  const CorLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 100,
          height: 100,
          child: RiveAnimation.asset("animacao/coracao.riv"),
        ),
      ),
    );
  }
}
