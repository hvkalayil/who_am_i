import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whoami/constants.dart';
import 'package:whoami/screens/ESocialMediaScreen/setup_social_medias.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File _image;
  String path, userName, jobTitle;
  double moveCard = 500;

  @override
  void initState() {
    initjobs();
    super.initState();
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        moveCard = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                curve: Curves.bounceIn,
                transform: Matrix4.translationValues(moveCard, 0, 0),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(FontAwesomeIcons.arrowLeft,color: primaryColor,size: 30,),
                        ),
                        SizedBox(width: 80),
                        Text('Register',style: font.copyWith(color: primaryColor,fontSize: 24),)
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Icon(
                              Icons.camera,
                              size: 40,
                              color: secondaryColor,
                            ),
                            onTap: () {
                              useImagePicker(true);
                            },
                          ),
                          CircleAvatar(
                            backgroundColor: secondaryColor,
                            radius: 80,
                            child: _image == null ? getDefaultIcon() : getImage(),
                          ),
                          GestureDetector(
                            onTap: () {
                              useImagePicker(false);
                            },
                            child: Icon(
                              Icons.image,
                              size: 40,
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: <Widget>[
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: TextField(
                              controller: TextEditingController(text: userName),
                              onChanged: (value) {
                                userName = value;
                              },
                              onSubmitted: (value) {
                                FocusScope.of(context).nextFocus();
                              },
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: primaryColor,
                              textAlign: TextAlign.center,
                              decoration:
                                  textFieldDecor.copyWith(labelText: 'Name')),
                        ),
                        SizedBox(height: 20),
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: TextField(
                              controller: TextEditingController(text: jobTitle),
                              onChanged: (value) {
                                jobTitle = value;
                              },
                              textInputAction: TextInputAction.go,
                              textCapitalization: TextCapitalization.words,
                              cursorColor: primaryColor,
                              textAlign: TextAlign.center,
                              decoration: textFieldDecor.copyWith(
                                  labelText: 'Job Title',
                                  hintText:
                                      'eg. Associate Manager,Home maker,etc.')),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            CustomButton(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              buttonPadding: EdgeInsets.all(0),
                              textColor: secondaryColor,
                              buttonColor: primaryColor,
                              buttonText: 'NEXT >',
                              onClick: () => onNextClick(),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initjobs() async {
    Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path;
    String temp = await SharedPrefUtils.readPrefStr('isLogRegDone');
    if (temp == 'yes') {
      String tempImage = await SharedPrefUtils.readPrefStr('profileImage');
      String tempName = await SharedPrefUtils.readPrefStr('userName');
      String tempJob = await SharedPrefUtils.readPrefStr('jobTitle');
      setState(() {
        userName = tempName;

        if (tempImage != def) _image = File(tempImage);

        if (tempJob != def) {
          jobTitle = tempJob;
        }
      });
    }
  }

  Icon getDefaultIcon() {
    return Icon(
      MyFlutterApp.icon2,
      size: 125,
      color: primaryColor,
    );
  }

  getImage() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(image: FileImage(_image), fit: BoxFit.cover),
      ),
    );
  }

  useImagePicker(bool isCamera) async {
    PickedFile pickedImage;
    File image;
    ImagePicker img = new ImagePicker();
    if (isCamera)
      pickedImage = await img.getImage(source: ImageSource.camera);
    else
      pickedImage = await img.getImage(source: ImageSource.gallery);

    image = File(pickedImage.path);
    var filename = basename(image.path);
    image = await image.copy('$path/$filename');
    setState(() {
      _image = image;
    });
  }

  onNextClick() async {
    if (userName == null || userName == '') {
      doToast('Please enter your name');
      return null;
    } else {
      SharedPrefUtils.saveStr('userName', userName);
    }

    if (_image == null) {
      SharedPrefUtils.saveStr('profileImage', def);
    } else {
      SharedPrefUtils.saveStr('profileImage', _image.path);
    }

    if (jobTitle == null || jobTitle == '') {
      SharedPrefUtils.saveStr('jobTitle', def);
    } else {
      SharedPrefUtils.saveStr('jobTitle', jobTitle);
    }
    Navigator.push(this.context,
        SlideRoute(widget: SetupSocialMedias(), begin: Offset(1, 0)));
  }
}
