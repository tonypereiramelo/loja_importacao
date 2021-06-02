import 'package:flutter/material.dart';

class BodyBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 28, 28, 28),
          Color.fromARGB(255, 192, 192, 192)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
    );
  }
}

class BodyDrawerBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color.fromARGB(255, 147, 112, 219), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
    );
  }
}

class FailLogin {
  String? text;
  FailLogin({this.text});
  VoidCallback? showSk() {
    ScaffoldMessenger(
        child: SnackBar(
      content: Text(text!),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 2),
    ));
  }
}
