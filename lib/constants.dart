import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

final Color primaryColor = Colors.lightBlueAccent[100];
final Color secondaryColor = Colors.white;

var textFieldDecor = InputDecoration(
  labelStyle: TextStyle(color: primaryColor, fontFamily: 'Bellotta'),
  filled: true,
  hintStyle: TextStyle(color: primaryColor, fontFamily: 'Bellotta'),
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderSide: BorderSide(width: 0),
    borderRadius: BorderRadius.all(
      Radius.circular(40),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0),
    borderRadius: BorderRadius.all(
      Radius.circular(40),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 4),
    borderRadius: BorderRadius.all(
      Radius.circular(40),
    ),
  ),
);

void doVibrate() async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: 75);
  }
}

void doToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: secondaryColor,
      fontSize: 20.0);
}
