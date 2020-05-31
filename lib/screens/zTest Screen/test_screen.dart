import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class TestScreen extends StatefulWidget {
  static String id = 'Test Screen';
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initJobs();
  }

  Firestore _database = Firestore.instance;
  initJobs() async {
    String uid = await SharedPrefUtils.readPrefStr('uid');
    final messages = await _database
        .collection('user details')
        .document('erFNjqzMaXk12yZugTUw')
        .get();
    print(uid);
    Map details = messages.data;
    List social = details['social'];

    print(social.length);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
