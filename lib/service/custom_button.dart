import 'package:flutter/material.dart';
import 'package:whoami/constants.dart';

class CustomButton extends StatelessWidget {
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
      this.buttonPadding});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: buttonPadding,
        child: RaisedButton(
          splashColor: secondaryColor.withAlpha(100),
          highlightColor: secondaryColor.withAlpha(50),
          autofocus: true,
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
