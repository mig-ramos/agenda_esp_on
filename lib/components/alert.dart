import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String msg) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ephemeris'),
          content: Text(msg),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            )
          ],
        );
      });
}


