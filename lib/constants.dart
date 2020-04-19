import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vibration/vibration.dart';

final Color primaryColor = Colors.lightBlueAccent[100];
final Color secondaryColor = Colors.white;
const String def = 'DEFAULT';
const String noFormat = 'NOFORMAT';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget, begin = const Offset(0.0, 1.0)})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: begin,
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

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

void doToast(String message,
    {Color bg = Colors.lightBlueAccent, Color txt = Colors.white}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: bg,
      textColor: txt,
      fontSize: 20.0);
}

makeDivider() {
  return Divider(
    color: Colors.blueGrey.withAlpha(50),
    thickness: 2,
    indent: 20,
    endIndent: 20,
  );
}
