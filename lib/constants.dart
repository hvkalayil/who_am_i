import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Color primaryColor = Colors.lightBlueAccent[100];
final Color secondaryColor = Colors.white;
const String def = 'Default';
const String noFormat = 'NOFORMAT';

findLabel(String url) {
  String x;
  if (url.contains('facebook')) x = 'Facebook';

  if (url.contains('instagram')) x = 'Instagram';

  if (url.contains('twitter')) x = 'Twitter';

  if (url.contains('linkedin')) x = 'Linked In';

  if (url.contains('tiktok')) x = 'Tikitok';

  if (url.contains('pinterest')) x = 'Pinterest';

  if (url.contains('dribbble')) x = 'Dribbble';

  if (url.contains('gmail')) x = 'Gmail';

  return x;
}

class SlideRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRoute({this.widget, begin = const Offset(0.0, 1.0)})
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

TextStyle font = TextStyle(fontFamily: 'Bellotta');
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

void doToast(String message,
    {Color bg = Colors.lightBlueAccent, Color txt = Colors.white}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
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
