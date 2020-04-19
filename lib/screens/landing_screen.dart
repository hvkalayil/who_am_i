import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/screens/settings_screen.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'LandingScreen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int index = 0;
  String profileImage, userName = '', jobTitle;
  Map<int, Map> social = Map<int, Map>();
  int socialAdded = 0;
  List<int> socialAddedList = [];
  List<String> profileList = [];
  List<String> linkList = [];
  List<String> formatList = [];
  List<String> labelList = [];
  List<String> files, titles;
  bool isImageExist = false,
      isJobExist = false,
      isSocialExist = false,
      isFileExist = false;
  int n = 0;

  void initJobs() async {
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

    List<String> socialAddedStrList =
        await SharedPrefUtils.readPrefStrList('socialAddedList');
    if (socialAddedStrList != null) {
      if (socialAddedStrList.length > -1) {
        List<int> socialAddedIntList =
            socialAddedStrList.map((i) => int.parse(i)).toList();
        int lastSocialAdded = socialAddedIntList.last;
        int length = socialAddedIntList.length;
        List<String> profileListTemp =
            await SharedPrefUtils.readPrefStrList('profileList');
        List<String> linkListTemp =
            await SharedPrefUtils.readPrefStrList('linkList');
        List<String> formatListTemp =
            await SharedPrefUtils.readPrefStrList('formatList');
        List<String> labelListTemp =
            await SharedPrefUtils.readPrefStrList('labelList');

        Map<int, Map> tempSocial = Map<int, Map>();
        for (int i = 0; i < length; i++) {
          tempSocial.addAll({
            socialAddedIntList[i]: {
              'profile': {'profile': profileListTemp[i]},
              'link': {'link': linkListTemp[i]},
              'format': {'format': formatListTemp[i]},
              'label': {'label': labelListTemp[i]},
            }
          });
        }
        setState(() {
          isSocialExist = true;
          social = tempSocial;
          socialAdded = lastSocialAdded + 1;
          socialAddedList = socialAddedIntList;
          profileList = profileListTemp;
          linkList = linkListTemp;
          formatList = formatListTemp;
          labelList = labelListTemp;
        });
      }
    }
    titles = await SharedPrefUtils.readPrefStrList('titles');
    files = await SharedPrefUtils.readPrefStrList('files');
    if (titles.elementAt(0) != 'Default' || files.elementAt(0) != 'Default')
      setState(() {
        isFileExist = true;
      });

    await SharedPrefUtils.saveStr('isLogRegDone', 'yes');

    return;
  }

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
                      Text(
                        userName,
                        style: TextStyle(
                            fontFamily: 'Bellotta',
                            color: secondaryColor,
                            fontSize: 30),
                      ),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: makeSocialList())
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: getFiles())
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
    );
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
      style: TextStyle(
          fontFamily: 'Bellotta', color: secondaryColor, fontSize: 20),
    );
  }

  makeSocialList() {
    List<Widget> socialMedias = [];
    int length = social.length ~/ 3;
    if (length >= 1) {
      for (int i = 1; i <= length; i++) {
        socialMedias.add(makeSocialRow(itr: 3));
      }
      int x = social.length % 3;
      if (x > 0) {
        socialMedias.add(makeSocialRow(itr: x));
      }
    } else {
      socialMedias.add(makeSocialRow(itr: social.length));
    }
    return Column(
      children: socialMedias,
    );
  }

  makeSocialRow({int itr}) {
    List<Widget> socialMediasRow = [];
    for (int i = 0; i < itr; i++) {
      for (int j = index; j <= social.length; j++) {
        if (social.containsKey(j)) {
          index++;
          IconData icon = findSocialIcon(media: social[j]['label']['label']);
          socialMediasRow.add(makeTile(social[j], j, icon));
          break;
        }
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: socialMediasRow,
    );
  }

  findSocialIcon({String media}) {
    IconData icon;
    if (media == 'Facebook')
      icon = MyFlutterApp.facebook;
    else if (media == 'Instagram')
      icon = MyFlutterApp.instagram;
    else if (media == 'Twitter')
      icon = MyFlutterApp.twitter;
    else if (media == 'Linkedin')
      icon = MyFlutterApp.linkedin;
    else if (media == 'Tiktok')
      icon = MyFlutterApp.tiktok;
    else if (media == 'Gmail')
      icon = Icons.mail_outline;
    else
      icon = Icons.battery_unknown;
    return icon;
  }

  makeTile(Map m, int index, IconData icon) {
    String user = m['profile']['profile'];
    String url = m['link']['link'];
    String format = m['format']['format'];
    String label = m['label']['label'];
    if (format != noFormat) user = user.replaceAll(' ', format);

    String userLink = url + user;

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () async {
          if (label == 'Gmail') {
            if (await canLaunch("mailto:$userLink")) {
              await launch("mailto:$userLink");
            }
          }
          if (await canLaunch(userLink)) {
            bool nativeLaunch = await launch(
              userLink,
              forceSafariVC: false,
              forceWebView: false,
              universalLinksOnly: true,
            );
            if (!nativeLaunch) {
              await launch(userLink, forceWebView: true, forceSafariVC: true);
            }
          } else {
            throw 'Could not launch $userLink';
          }
        },
        child: CircleAvatar(
            radius: 32,
            backgroundColor: secondaryColor,
            child: Icon(
              icon,
              color: primaryColor,
            )),
      ),
    );
  }

  getFiles() {
    return divideFiles();
  }

  divideFiles() {
    n = 0;
    List<Widget> fileSet = [];
    int m = files.length;
    if (m >= 0) {
      if (m / 3 >= 1) {
        for (int i = 1; i <= m / 3; i++) {
          fileSet.add(makeFilesRow(itr: 3));
        }
        int x = (m % 3).toInt();
        if (x > 0) {
          fileSet.add(makeFilesRow(itr: x));
        }
      } else {
        fileSet.add(makeFilesRow(itr: m));
      }
      return Column(
        children: fileSet,
      );
    }
  }

  makeFilesRow({int itr}) {
    List<Widget> filesRow = [];
    IconData fileIcon;
    for (int i = 1; i <= itr; i++) {
      fileIcon = findIcon(index: n);
      String text = titles.elementAt(n);
      filesRow.add(makeFilesRowElement(index: n, ico: fileIcon, title: text));
      n++;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: filesRow,
    );
  }

  findIcon({int index}) {
    String title = titles.elementAt(index).toUpperCase();
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
