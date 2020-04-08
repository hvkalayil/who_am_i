import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whoami/screens/social_media_setup_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/my_flutter_app_icons.dart';
import 'package:whoami/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:whoami/service/shared_prefs_util.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  File _image;
  String path, userName, jobTitle;

  @override
  void initState() {
    initjobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Container(
                  color: primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      SizedBox(
                        width: 20,
                      ),
                      CircleAvatar(
                        backgroundColor: secondaryColor,
                        radius: 100,
                        child: _image == null ? getDefaultIcon() : getImage(),
                      ),
                      SizedBox(
                        width: 20,
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
              ),
              Flexible(
                flex: 6,
                fit: FlexFit.loose,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 20, right: 20),
                    child: Column(
                      children: <Widget>[
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: TextField(
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
                        SizedBox(
                          height: 20,
                        ),
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: TextField(
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
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                  color: secondaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                        buttonPadding: EdgeInsets.all(0),
                        textColor: secondaryColor,
                        buttonColor: primaryColor,
                        buttonText: 'NEXT >',
                        onClick: () => onNextClick(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initjobs() async {
    Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path;
  }

  Icon getDefaultIcon() {
    return Icon(
      MyFlutterApp.icon2,
      size: 125,
      color: primaryColor,
    );
  }

  Container getImage() {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        image: DecorationImage(image: FileImage(_image), fit: BoxFit.cover),
      ),
    );
  }

  void useImagePicker(bool isCamera) async {
    File image;
    if (isCamera)
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    else
      image = await ImagePicker.pickImage(source: ImageSource.gallery);

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

    SharedPrefUtils.saveStr('userName', userName);
    doVibrate();
    Navigator.pushNamed(this.context, SocialMediaSetupScreen.id);
  }
}
