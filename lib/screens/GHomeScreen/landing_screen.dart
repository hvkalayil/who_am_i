import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/screens/HSettingsScreen/settings_screen.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'LandingScreen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String profileImage = '', userName = '', jobTitle = '';
  List<String> socialMediaUrl = [];
  List<String> files, titles;
  bool isImageExist = false,
      isJobExist = false,
      isSocialExist = false,
      isFileExist = false;
  final Firestore _database = Firestore.instance;
  http.Client httpClient = http.Client();
  bool fetching = true;
  QuerySnapshot messages;
//  StorageFileDownloadTask _task;
//  final FirebaseStorage _storage =
//      FirebaseStorage(storageBucket: 'gs://who-am-i-d8752.appspot.com');
  bool useCloud;

  @override
  void initState() {
    initJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool x =
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return x;
      },
      child: Scaffold(
        backgroundColor: primaryColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: primaryColor),
          child: SafeArea(
            child: ModalProgressHUD(
              inAsyncCall: fetching,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        CircleAvatar(
                            radius: 100,
                            backgroundColor: secondaryColor,
                            child: isImageExist
                                ? getProfileIcon()
                                : getDefaultIcon()),
                        SizedBox(
                          height: 10,
                        ),
                        Text(userName,
                            style: font.copyWith(
                                color: secondaryColor, fontSize: 30)),
                        Container(
                          child: isJobExist
                              ? getJob()
                              : Container(color: secondaryColor),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: isSocialExist
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: secondaryColor, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: makeSocialList(),
                                  ),
                                )
                              : SizedBox(height: 0),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: isFileExist
                              ? Container(
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: secondaryColor, width: 5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: makeFiles(),
                                  ))
                              : SizedBox(height: 0),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.settings,
                            color: secondaryColor,
                            size: 40,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, SettingsScreen.id);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  initJobs() async {
    String isDone = await SharedPrefUtils.readPrefStr('isSignUpDone');
    String isCloud = await SharedPrefUtils.readPrefStr('isFirstTimeCloud');

    if (isDone == 'yes' && isCloud == 'yes') {
      print('something');
      setState(() {
        useCloud = true;
      });
      await dataFromCloud();
    } else {
      print('something');
      setState(() {
        useCloud = false;
      });
      await dataFromSharedPrefs();
    }

    await SharedPrefUtils.saveStr('isLogRegDone', 'yes');
  }

  dataFromCloud() async {
    String uid = await SharedPrefUtils.readPrefStr('uid');
    Map details;
    var x = await _database.collection('user details').getDocuments();
    for (var a in x.documents) {
      if (a.documentID == uid) {
        details = a.data;
        break;
      }
    }

    String tempName = details['name'];
    String tempJob = details['job'];
    List ts = details['social'];
    List<String> tempSocial = [];
    if (ts != null) {
      for (int i = 0; i < ts.length; i++) tempSocial.add(ts[i]);
    }

    List tt = details['titles'];
    List<String> tempTitles = [];
    if (tt != null) {
      for (int i = 0; i < tt.length; i++) tempTitles.add(tt[i]);
    }

    List tl = details['links'];
    List<String> tempLinks = [];
    if (tl != null) {
      for (int i = 0; i < tl.length; i++) tempLinks.add(tl[i]);
      print(tempLinks);
    }

    List tf = details['filenames'];
    List<String> tempFilenames = [];
    if (tf != null) {
      for (int i = 0; i < tf.length; i++) tempFilenames.add(tf[i]);
      print(tempFilenames);
    }

    List<File> tempRealFiles = [];
    List<String> tempFiles = [];
    String tempProfile = '';
    if (tl != null) {
      for (int i = 0; i < tempLinks.length; i++) {
        var request = await httpClient.get(Uri.parse(tempLinks[i]));
        var bytes = request.bodyBytes;
        String dir = (await getApplicationDocumentsDirectory()).path;
        File file = File('$dir/${tempFilenames[i]}');
        await file.writeAsBytes(bytes);
        tempRealFiles.add(file);
      }
      print(tempRealFiles);

      if (tempRealFiles.length != tempTitles.length) {
        tempProfile = tempRealFiles[0].path;
        for (int i = 1; i < tempRealFiles.length; i++)
          tempFiles.add(tempRealFiles[i].path);
      } else {
        for (int i = 0; i < tempRealFiles.length; i++)
          tempFiles.add(tempRealFiles[i].path);
      }
      print(tempFiles);
    }

    //*****************SETSTATE****************************
    if (tempProfile != null) {
      if (tempProfile != '') {
        setState(() {
          isImageExist = true;
          profileImage = tempProfile;
        });
      }
    }
    setState(() {
      userName = tempName;
    });

    if (tempJob != null) {
      if (tempJob != '') {
        setState(() {
          isJobExist = true;
          jobTitle = tempJob;
        });
      }
    }

    if (tempSocial != null && tempSocial.isNotEmpty) {
      print('WTFFFFFFFFFF $tempSocial');
      setState(() {
        isSocialExist = true;
        socialMediaUrl = tempSocial;
      });
    }

    if (tempTitles != null && tempTitles.isNotEmpty) {
      setState(() {
        isFileExist = true;
        titles = tempTitles;
        files = tempFiles;
      });
    }
    setState(() {
      fetching = false;
    });
    print('as${profileImage}asa');
    print(userName);
    print(jobTitle);
    print(socialMediaUrl);
    print(titles);
    print(files);
    print(isImageExist);
    print(isJobExist);
    print(isSocialExist);
    print(isFileExist);

    isImageExist
        ? await SharedPrefUtils.saveStr('profileImage', profileImage)
        : await SharedPrefUtils.saveStr('profileImage', def);

    await SharedPrefUtils.saveStr('userName', userName);

    isJobExist
        ? await SharedPrefUtils.saveStr('jobTitle', jobTitle)
        : await SharedPrefUtils.saveStr('jobTitle', def);

    isSocialExist
        ? await SharedPrefUtils.saveStrList('socialLinks', socialMediaUrl)
        : await SharedPrefUtils.saveStrList('socialLinks', [def]);

    isFileExist
        ? await SharedPrefUtils.saveStrList('titles', titles)
        : await SharedPrefUtils.saveStrList('titles', [def]);

    isFileExist
        ? await SharedPrefUtils.saveStrList('files', files)
        : await SharedPrefUtils.saveStrList('files', [def]);

    await SharedPrefUtils.saveStr('isFirstTimeCloud', 'no');
  }

  dataFromSharedPrefs() async {
    String tempProfileImage = await SharedPrefUtils.readPrefStr('profileImage');
    setState(() {
      profileImage = tempProfileImage;
    });
    if (profileImage != def) {
      setState(() {
        isImageExist = true;
      });
    }
    String tempUserName = await SharedPrefUtils.readPrefStr('userName');
    setState(() {
      userName = tempUserName;
    });
    String tempJobTitle = await SharedPrefUtils.readPrefStr('jobTitle');
    setState(() {
      jobTitle = tempJobTitle;
    });
    if (jobTitle != def) {
      setState(() {
        isJobExist = true;
      });
    }

    List<String> temp = await SharedPrefUtils.readPrefStrList('socialLinks');
    if (temp != null) {
      if (temp.isNotEmpty && temp[0] != def) {
        setState(() {
          isSocialExist = true;
          socialMediaUrl = temp;
        });
      }
    }

    titles = await SharedPrefUtils.readPrefStrList('titles');
    files = await SharedPrefUtils.readPrefStrList('files');
    if (titles.elementAt(0) != def || files.elementAt(0) != def)
      setState(() {
        isFileExist = true;
      });

    setState(() {
      fetching = false;
    });
  }

  Container getProfileIcon() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(
            image: FileImage(File(profileImage)), fit: BoxFit.cover),
      ),
    );
  }

  Icon getDefaultIcon() {
    return Icon(
      MyFlutterApp.icon2,
      size: 125,
      color: primaryColor,
    );
  }

  Text getJob() {
    return Text(
      jobTitle,
      style: font.copyWith(color: secondaryColor, fontSize: 20),
    );
  }

  makeSocialList() {
    List<Widget> socialMedias = [];
    int length = socialMediaUrl.length;
    for (int i = 0; i < length; i++) {
      String media = findLabel(socialMediaUrl[i]);
      IconData ico = findSocialIcon(media);
      socialMedias.add(makeTile(socialMediaUrl[i], i, media, ico));
    }
    return socialMedias;
  }

  findSocialIcon(String media) {
    IconData x;
    if (media == 'Facebook') x = MyFlutterApp.facebook;

    if (media == 'Instagram') x = MyFlutterApp.instagram;

    if (media == 'Twitter') x = MyFlutterApp.twitter;

    if (media == 'Linked In') x = MyFlutterApp.linkedin;

    if (media == 'Tikitok') x = MyFlutterApp.tiktok;

    if (media == 'Pinterest') x = MyFlutterApp.pinterest;

    if (media == 'Dribbble') x = MyFlutterApp.dribbble;

    if (media == 'Gmail') x = Icons.mail;

    return x;
  }

  makeTile(String link, int index, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () async {
          if (label == 'Gmail') {
            if (await canLaunch("mailto:$link")) {
              await launch("mailto:$link");
            }
          }
          if (await canLaunch(link)) {
            bool nativeLaunch = await launch(
              link,
              forceSafariVC: false,
              forceWebView: false,
              universalLinksOnly: true,
            );
            if (!nativeLaunch) {
              await launch(link, forceWebView: true, forceSafariVC: true);
            }
          } else {
            throw 'Could not launch $link';
          }
        },
        child: CircleAvatar(
            radius: 32,
            backgroundColor: secondaryColor,
            child: Icon(
              icon,
              size: 30,
              color: primaryColor,
            )),
      ),
    );
  }

  makeFiles() {
    List<Widget> filesRow = [];
    IconData fileIcon;
    for (int i = 0; i < titles.length; i++) {
      String text = titles[i];
      fileIcon = findIcon(text.toUpperCase());
      filesRow.add(makeFilesRowElement(index: i, ico: fileIcon, title: text));
    }
    return filesRow;
  }

  findIcon(String title) {
    IconData ico;

    if (title.contains('LICENSE') || title.contains('DRIVING')) {
      ico = MyFlutterApp.driving;
    } else if (title.contains('AADHAR') ||
        title.contains('ADHAR') ||
        title.contains('UID')) {
      ico = MyFlutterApp.uid;
    } else if (title.contains('PAN')) {
      ico = MyFlutterApp.pan;
    } else {
      ico = MyFlutterApp.id;
    }

    return ico;
  }

  makeFilesRowElement({int index, IconData ico, String title}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onLongPress: () {
          doToast(title, bg: secondaryColor, txt: primaryColor);
        },
        onTap: () async {
          await OpenFile.open(files.elementAt(index));
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Icon(
            ico,
            color: primaryColor,
            size: 60,
          ),
        ),
      ),
    );
  }
}
