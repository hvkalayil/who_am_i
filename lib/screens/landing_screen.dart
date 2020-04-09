import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isImageExist = false, isJobExist = false, isSocialExist = false;
  void initJobs() async {
    //Get all data from SharedPrefs
    /*
    profileImage,
    userName
    jobTitle
    fbName
    igName
    twitterName
    linkedinName
    tiktokName
    mailName
    titles
    files
     */
//    profileImage = '';
//    userName = '';
//    jobTitle = '';
//    fbName = '';
//    igName = '';
//    twitterName = '';
//    linkedinName = '';
//    tiktokName = '';
//    mailName = '';
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

    setState(() {
      print('$profileImage $userName $jobTitle $fbName $igName');
    });
    return;
  }

  @override
  void initState() {
    initJobs();
    super.initState();
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

  getSocialIcons() {
    List<GestureDetector> socialIcons = [];
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

  GestureDetector makeSocial({IconData ico, String link}) {
    return GestureDetector(
        onTap: () async {
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
            )));
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: secondaryColor,
                      child:
                          isImageExist ? getProfileIcon() : getDefaultIcon()),
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
                  Container(
                    child: isSocialExist
                        ? Row(children: getSocialIcons())
                        : Container(color: secondaryColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
