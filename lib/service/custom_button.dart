import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  EdgeInsetsGeometry buttonPadding;
  String buttonText;
  Function onClick;
  Color buttonColor;
  Color textColor;

  CustomButton(
      {this.buttonText,
      this.onClick,
      this.buttonColor,
      this.textColor,
      this.buttonPadding});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: buttonPadding,
        child: RaisedButton(
          color: buttonColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onPressed: onClick,
          child: Text(
            buttonText,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor, fontFamily: 'Bellotta', fontSize: 20),
          ),
        ),
      ),
    );
  }
}
