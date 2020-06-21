import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

bool isRunning = false, isSignDone = false;
FirebaseUser user;
String uid;
double moveCard = 500, options = 500;
bool refresh = false;

checkConn() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
}
