import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CorLoadding extends StatelessWidget {
  const CorLoadding({Key? key}) : super(key: key);

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
