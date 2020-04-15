import 'package:flutter/material.dart';

Widget widgetMessage(String message, IconData icon) {  
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(message),
        Icon(icon),
      ],
    ),
  );
}