import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whoami/screens/landing_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../constants.dart';

//List<IconData> iconList = [];

String docTitle;
List<String> titleList = [];
List<File> documents = [];
int fileAdded = 0;
bool isFileThere = false;

class DocUploadScreen extends StatefulWidget {
  static String id = 'DocUploadScreen';
  @override
  _DocUploadScreenState createState() => _DocUploadScreenState();
}

class _DocUploadScreenState extends State<DocUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: primaryColor),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Container(
                  color: primaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Add Personal Documents',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            decoration: TextDecoration.underline,
                            fontSize: 36,
                            color: secondaryColor,
                            fontFamily: 'Bellotta'),
                      ),
                      Text(
                        'You can skip this step if you want.\n Use Add button below to add documents.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: secondaryColor,
                            fontFamily: 'Bellotta'),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                fit: FlexFit.loose,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  padding: EdgeInsets.only(top: 25),
                  child: isFileThere
                      ? ListView(children: makeDocList())
                      : Center(
                          child: Text(
                            'No Documents Uploaded. Use Add buton to select your document',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: primaryColor.withAlpha(120),
                                fontFamily: 'Bellotta'),
                          ),
                        ),
                ),
              ),
              makeButton(context),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomButton(
                    buttonText: '< PREVIOUS',
                    onClick: () {
                      doVibrate();
                      Navigator.pop(context);
                    },
                    buttonColor: secondaryColor,
                    textColor: primaryColor,
                    buttonPadding: EdgeInsets.zero,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  CustomButton(
                    buttonText: 'FINISH',
                    onClick: () {
                      onFinishClick(context);
                    },
                    buttonColor: secondaryColor,
                    textColor: primaryColor,
                    buttonPadding: EdgeInsets.zero,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void addClick(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (_) {
          return CreateAlertDialog();
        });
    Navigator.popAndPushNamed(context, DocUploadScreen.id);
  }

  Container makeButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 0, right: 0, bottom: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40))),
        color: secondaryColor,
        onPressed: () => addClick(context),
        textTheme: ButtonTextTheme.accent,
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add,
              color: primaryColor,
            ),
            Text(
              'Add Document',
              style: TextStyle(
                  fontSize: 18, color: primaryColor, fontFamily: 'Bellotta'),
            )
          ],
        ),
      ),
    );
  }

  List<ListTile> makeDocList() {
    List<ListTile> docList = [];
    for (int i = 0; i < fileAdded; i++) {
      String title = titleList[i];
      String fpath = documents[i].path;
      docList.add(makeSingleTile(text: title, filePath: fpath));
    }
    return docList;
  }

  ListTile makeSingleTile({String text, String filePath}) {
    return ListTile(
      title: RaisedButton(
        onPressed: () async {
          await OpenFile.open(filePath);
        },
        padding: EdgeInsets.all(16),
        color: primaryColor,
        child: Text(
          text,
          style: TextStyle(color: secondaryColor),
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            if (fileAdded == 1) isFileThere = false;
            fileAdded--;
            documents.removeLast();
            titleList.removeLast();
          });
        },
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
    );
  }

  onFinishClick(BuildContext context) {
    if (fileAdded == 0) {
      SharedPrefUtils.saveStrList('titles', ['Default']);
      SharedPrefUtils.saveStrList('files', ['Default']);
    } else {
      List<String> tempDoc = [];
      for (int i = 0; i < fileAdded; i++) {
        tempDoc.add(documents[i].path);
      }
      SharedPrefUtils.saveStrList('titles', titleList);
      SharedPrefUtils.saveStrList('files', tempDoc);
    }
    Navigator.pushNamed(context, LandingScreen.id);
  }
}

//******************************************************************************

class CreateAlertDialog extends StatefulWidget {
  static String id = 'CreateAlertDialog';
  @override
  _CreateAlertDialogState createState() => _CreateAlertDialogState();
}

class _CreateAlertDialogState extends State<CreateAlertDialog> {
  IconData icon;
  bool isIconSet = false;
  File file;
  String path;

  //TODO: Provide as an Update later
//  void pickIcon(BuildContext context) async {
//    IconData tempicon = await FlutterIconPicker.showIconPicker(context);
//    if (tempicon != null) {
//      setState(() {
//        isIconSet = true;
//        icon = tempicon;
//      });
//    }
//  }

  void addDocs(BuildContext context) async {
    File tempFile = await FilePicker.getFile();
    var filename = basename(tempFile.path);
    file = await tempFile.copy('$path/$filename');
    if (file != null) {
      setState(() {
        documents.add(file);
        fileAdded++;
        isFileThere = true;
      });
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void initjobs() async {
    Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path;
  }

  @override
  void initState() {
    initjobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Enter Document Details',
        style: TextStyle(
            color: primaryColor, fontFamily: 'Bellotta', fontSize: 24),
      ),
      contentTextStyle:
          TextStyle(color: primaryColor, fontFamily: 'Bellotta', fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //PART of UPDATE
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text('Icon:'),
//              isIconSet
//                  ? Icon(icon)
//                  : RaisedButton(
//                      onPressed: () => pickIcon(context),
//                      color: primaryColor,
//                      child: Text(
//                        'Choose Icon',
//                        style: TextStyle(
//                            color: secondaryColor,
//                            fontFamily: 'Bellotta',
//                            fontSize: 20),
//                      ),
//                    ),
//            ],
//          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            onChanged: (value) {
              setState(() {
                docTitle = value;
              });
            },
            decoration: textFieldDecor.copyWith(
                labelText: 'Document Type',
                hintText: 'eg: Driving License,PAN card,etc'),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
                color: Colors.red, fontFamily: 'Bellotta', fontSize: 20),
          ),
        ),
        FlatButton(
          onPressed: () {
            if (docTitle == '' || docTitle == null) {
              doToast('Please enter a title for your document');
              return;
            } else {
              setState(() {
                titleList.add(docTitle);
              });
              addDocs(this.context);
            }
          },
          child: Text(
            'Upload',
            style: TextStyle(
                color: primaryColor, fontFamily: 'Bellotta', fontSize: 20),
          ),
        ),
      ],
    );
  }
}
