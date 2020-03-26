import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';

class CustomButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry buttonPadding;
  final String buttonText;
  final Function onClick;
  final Color buttonColor;
  final Color textColor;

  CustomButton(
      {this.buttonText,
      this.onClick,
      this.buttonColor,
      this.textColor,
      this.buttonPadding,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: buttonPadding,
      child: RaisedButton(
        splashColor: secondaryColor.withAlpha(100),
        highlightColor: secondaryColor.withAlpha(50),
        autofocus: true,
        color: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        onPressed: onClick,
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style:
              TextStyle(color: textColor, fontFamily: 'Bellotta', fontSize: 20),
        ),
      ),
    );
  }
}
