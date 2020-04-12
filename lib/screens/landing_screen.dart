import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';

class LandingScreen extends StatefulWidget {
  static String id = 'LandingScreen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String profileImage,
      userName,
      jobTitle,
      fbName,
      igName,
      twitterName,
      linkedinName,
      tiktokName,
      mailName;
  List<String> files, titles;
  bool isImageExist = false,
      isJobExist = false,
      isSocialExist = false,
      isFileExist = false;
  int n = 0;

  void initJobs() async {
    profileImage = await SharedPrefUtils.readPrefStr('profileImage');
    if (profileImage != def) {
      setState(() {
        isImageExist = true;
      });
    }
    userName = await SharedPrefUtils.readPrefStr('userName');
    jobTitle = await SharedPrefUtils.readPrefStr('jobTitle');
    if (jobTitle != def) {
      setState(() {
        isJobExist = true;
      });
    }
    fbName = await SharedPrefUtils.readPrefStr('fbName');
    igName = await SharedPrefUtils.readPrefStr('igName');
    twitterName = await SharedPrefUtils.readPrefStr('twitterName');
    linkedinName = await SharedPrefUtils.readPrefStr('linkedinName');
    tiktokName = await SharedPrefUtils.readPrefStr('tiktokName');
    mailName = await SharedPrefUtils.readPrefStr('mailName');
    if (fbName != def ||
        igName != def ||
        twitterName != def ||
        linkedinName != def ||
        tiktokName != def ||
        mailName != def) {
      setState(() {
        isSocialExist = true;
      });
    }
    titles = await SharedPrefUtils.readPrefStrList('titles');
    files = await SharedPrefUtils.readPrefStrList('files');
    if (titles.elementAt(0) != 'Default' || files.elementAt(0) != 'Default')
      setState(() {
        isFileExist = true;
      });
    return;
  }

  @override
  void initState() {
    initJobs();
    super.initState();
  }

  getFiles() {
    return divideFiles();
  }

  divideFiles() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: secondaryColor,
                      child:
                          isImageExist ? getProfileIcon() : getDefaultIcon()),
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
                    height: 40,
                  ),
                  Container(
                    child: isSocialExist
                        ? Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: secondaryColor, width: 5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              children: <Widget>[
                                Row(children: getSocialIcons1()),
                                Row(children: getSocialIcons2())
                              ],
                            ))
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
                                border:
                                    Border.all(color: secondaryColor, width: 5),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: getFiles())
                        : SizedBox(height: 0),
                  ),
                ],
              ),
            ],
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

  getSocialIcons1() {
    List<Widget> socialIcons = [];
    if (fbName != def) {
      String fbProfile = fbName.replaceAll(' ', '.');
      String url = 'https://www.facebook.com/$fbProfile';
      socialIcons.add(makeSocial(ico: MyFlutterApp.facebook, link: url));
    }
    if (igName != def) {
      String url = 'https://www.instagram.com/$igName';
      socialIcons.add(makeSocial(ico: MyFlutterApp.instagram, link: url));
    }
    if (twitterName != def) {
      String url = 'https://twitter.com/$twitterName';
      socialIcons.add(makeSocial(ico: MyFlutterApp.twitter, link: url));
    }
    return socialIcons;
  }

  getSocialIcons2() {
    List<Widget> socialIcons = [];
    if (linkedinName != def) {
      String linProfile = linkedinName.replaceAll(' ', '%20');
      String url =
          'https://www.linkedin.com/search/results/people/?keywords=$linProfile';
      socialIcons.add(makeSocial(ico: MyFlutterApp.linkedin, link: url));
    }
    if (tiktokName != def) {
      String url = 'https://www.tiktok.com/@$fbName';
      socialIcons.add(makeSocial(ico: MyFlutterApp.tiktok, link: url));
    }
    if (mailName != def) {
      socialIcons.add(makeSocial(ico: Icons.mail_outline, link: mailName));
    }
    return socialIcons;
  }

  makeSocial({IconData ico, String link}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
          onTap: () async {
            if (ico == Icons.mail_outline) {
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
                ico,
                color: primaryColor,
                size: 32,
              ))),
    );
  }
}
