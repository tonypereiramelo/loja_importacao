import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final int? status;
  final int? thisStatus;
  StatusWidget(this.title, this.subTitle, this.status, this.thisStatus);

  @override
  Widget build(BuildContext context) {
    Color? backColor;
    Widget? child;

    if (status! < thisStatus!) {
      backColor = Colors.grey[500];
      child = Text(
        title!,
        style: TextStyle(color: Colors.white),
      );
    } else if (status! == thisStatus!) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title!,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check);
    }
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle!)
      ],
    );
  }
}
