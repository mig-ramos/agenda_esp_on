import 'package:flutter/material.dart';


ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    textStyle: TextStyle(fontSize: 28, color: Colors.black),
    onPrimary: Colors.white,
    primary: Colors.green,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ));

ButtonStyle textButtonStyle = TextButton.styleFrom(
  textStyle: TextStyle(fontSize: 26, color: Colors.black),
  primary: Colors.pink,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 6),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
  ),
);