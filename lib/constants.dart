import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final Color primaryColor = Colors.lightBlueAccent[100];
final Color secondaryColor = Colors.white;
const String def = 'Default';
const String noFormat = 'NOFORMAT';

Map<String, Map<String, String>> medias = {
  'facebook': {'https://www.facebook.com/': '.'},
  'instagram': {'https://www.instagram.com/': noFormat},
  'twitter': {'https://twitter.com/': noFormat},
  'linkedin': {
    'https://www.linkedin.com/search/results/people/?keywords=': '%20'
  },
  'tiktok': {'https://www.tiktok.com/@': noFormat},
  'pinterest': {'https://in.pinterest.com/': noFormat},
  'dribbble': {'https://dribbble.com/': noFormat},
  'gmail': {'https://www.gmail.com': noFormat},
};

findLabel(String url) {
  for (var name in medias.keys) {
    if (url.contains(name)) {
      return name.substring(0, 1).toUpperCase() + name.substring(1);
    }
  }
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

TextStyle font = TextStyle(fontFamily: 'Quicksand');

var textFieldDecor = InputDecoration(
  labelStyle: TextStyle(color: primaryColor, fontFamily: 'Quicksand'),
  filled: true,
  hintStyle: TextStyle(color: primaryColor, fontFamily: 'Quicksand'),
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
