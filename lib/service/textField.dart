import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';

class textField extends StatelessWidget {
  String text;
  textField({this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.black,
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
      child: TextField(
        textInputAction: TextInputAction.next,
        obscureText: text == 'Password' ? true : false,
        textCapitalization: TextCapitalization.words,
        cursorColor: primaryColor,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(color: primaryColor, fontFamily: 'Bellotta'),
          filled: true,
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
        ),
      ),
    );
  }
}
