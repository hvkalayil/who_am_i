import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/HSettingsScreen/encrypt_data.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key key,
    @required this.isProfile,
    @required this.path,
    @required this.name,
    @required this.index,
  }) : super(key: key);

  final bool isProfile;
  final String path;
  final String name;
  final int index;

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {

  http.Client httpClient = http.Client();
  bool fetch = true;
  // ignore: non_constant_identifier_names
  String dec_path;

  ModalProgressHUD getProfileIcon(){
    return ModalProgressHUD(
      inAsyncCall: fetch,
      progressIndicator: CircularProgressIndicator(),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          image:
          DecorationImage(image: FileImage(File(dec_path)), fit: BoxFit.cover,),
        ),
      ),
    );
  }

  Icon getDefaultIcon() {
    return Icon(
      MyFlutterApp.icon2,
      size: 40,
      color: primaryColor,
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1),(){
      initJobs();
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      return CircleAvatar(
        backgroundColor: primaryColor,
        radius: 40,
        child:
        widget.isProfile
            ? getProfileIcon()
            : getDefaultIcon(),
      );
    }  catch (e) {
      return  Container(
        width: 40,
        height: 40,
        child: ModalProgressHUD(
          inAsyncCall: fetch,
          progressIndicator: CircularProgressIndicator(),
          child: CircleAvatar(backgroundColor: primaryColor,
            radius: 40,),
        ),
      );
    }
  }

  initJobs() async {
    String tempDecPath;
    List<String> _friendUID =
        await SharedPrefUtils.readPrefStrList('friendUID') ?? [];
    List<String> profileImages = await SharedPrefUtils.readPrefStrList('friendProImg') ?? [];
    if(profileImages.length <= widget.index) {
      var request = await httpClient.get(Uri.parse(widget.path));
      var bytes = request.bodyBytes;
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File('$dir/${widget.name}');
      await file.writeAsBytes(bytes);
      tempDecPath = EncryptData.decrypt_file(
          file.path, key: _friendUID[widget.index]);
      profileImages.add(tempDecPath);
      await SharedPrefUtils.saveStrList('friendProImg', profileImages);
    }
    else{
      tempDecPath = profileImages[widget.index];
    }
    setState(() {
    fetch = false;
    dec_path = tempDecPath;
    });
  }
}