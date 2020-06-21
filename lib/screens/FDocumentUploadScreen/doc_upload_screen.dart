import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whoami/screens/AGOD/app_state.dart';
import 'package:whoami/screens/GHomeScreen/landing_screen.dart';
import 'package:whoami/service/custom_button.dart';
import 'package:whoami/service/shared_prefs_util.dart';

import '../../constants.dart';

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
  void initState() {
    initJos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LifeCycleManager(
      id: DocUploadScreen.id,
      child: Scaffold(
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
                        Text('Add Personal Documents',
                            textAlign: TextAlign.center,
                            style: font.copyWith(
                              fontWeight: FontWeight.w900,
                              decoration: TextDecoration.underline,
                              fontSize: 36,
                              color: secondaryColor,
                            )),
                        Text(
                          'You can skip this step if you want.\n Use Add button below to add documents.',
                          textAlign: TextAlign.center,
                          style:
                              font.copyWith(fontSize: 18, color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),

                //****************************************************************
                //BODY

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
                              'No Documents Uploaded. Use Add button to select your document',
                              textAlign: TextAlign.center,
                              style: font.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 26,
                                color: primaryColor.withAlpha(120),
                              ),
                            ),
                          ),
                  ),
                ),
                makeButton(context),
                SizedBox(
                  height: 20,
                ),

                //****************************************************************
                // PREVIOUS AND FINISH BUTTONS

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomButton(
                      buttonText: '< PREVIOUS',
                      onClick: () {
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
      ),
    );
  }

  initJos() async {
    List<String> temptitles = await SharedPrefUtils.readPrefStrList('titles');
    List<String> tempfilepath = await SharedPrefUtils.readPrefStrList('files');
    if (temptitles != null) {
      if (temptitles.isNotEmpty) {
        List<File> tempfiles = [];
        int length = tempfilepath.length;
        for (int i = 0; i < length; i++) {
          tempfiles.add(File(tempfilepath[i]));
        }
        if (temptitles[0] != 'Default') {
          setState(() {
            isFileThere = true;
            fileAdded = length;
            titleList = temptitles;
            documents = tempfiles;
          });
        }
      }
    }
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
              style: font.copyWith(
                fontSize: 18,
                color: primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<ListTile> makeDocList() {
    int n = 0;
    List<ListTile> docList = [];
    for (int i = 0; i < documents.length; i++) {
      String title = titleList[i];
      String fpath = documents[i].path;
      docList.add(makeSingleTile(text: title, filePath: fpath, index: n));
      n++;
    }
    return docList;
  }

  ListTile makeSingleTile({String text, String filePath, int index}) {
    return ListTile(
      title: RaisedButton(
        onPressed: () async {
          await OpenFile.open(filePath);
        },
        padding: EdgeInsets.all(10),
        color: primaryColor,
        child: Text(
          text,
          style: font.copyWith(color: secondaryColor, fontSize: 24),
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          setState(() {
            if (fileAdded == 1) isFileThere = false;
            documents.removeAt(index);
            titleList.removeAt(index);
            fileAdded--;
          });
        },
        child: Icon(
          Icons.cancel,
          color: Colors.red,
        ),
      ),
    );
  }

  onFinishClick(BuildContext context) async {
    if (fileAdded == 0) {
      await SharedPrefUtils.saveStrList('titles', [def]);
      await SharedPrefUtils.saveStrList('files', [def]);
    } else {
      List<String> tempDoc = [];
      for (int i = 0; i < fileAdded; i++) {
        tempDoc.add(documents[i].path);
      }
      await SharedPrefUtils.saveStrList('titles', titleList);
      await SharedPrefUtils.saveStrList('files', tempDoc);
      String isSignUp = await SharedPrefUtils.readPrefStr('isSignUpDone');
      if (isSignUp == 'yes') {
        doToast('Upload data to cloud by going into settings',
            bg: primaryColor, txt: secondaryColor);
      }
    }
    await SharedPrefUtils.saveStr('isLogRegDone', 'yes');
    Navigator.pushNamedAndRemoveUntil(
        context, LandingScreen.id, (Route<dynamic> route) => false);
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

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 80,
    );

    return result;
  }

  void addCamDocs(BuildContext context) async {
    ImagePicker picker = new ImagePicker();
    PickedFile pickedTempFile =
        await picker.getImage(source: ImageSource.camera);
    if(pickedTempFile != null) {
      File tempFile = File(pickedTempFile.path);
      var filename = basename(tempFile.path);
      file = await testCompressAndGetFile(tempFile, '$path/$filename');
      setState(() {
        documents.add(file);
        fileAdded++;
        isFileThere = true;
      });
      List<String> tempDoc = [];
      for (int i = 0; i < documents.length; i++) {
        tempDoc.add(documents[i].path);
      }
      await SharedPrefUtils.saveStrList('files', tempDoc);
      await SharedPrefUtils.saveStrList('titles', titleList);
      Navigator.of(context, rootNavigator: true).pop();
    }
    else{
      titleList.removeLast();
    }
  }

  void addDocs(BuildContext context) async {
    File tempFile = await FilePicker.getFile();
    if(tempFile != null) {
      var filename = basename(tempFile.path);
      try {
        file = await testCompressAndGetFile(tempFile, '$path/$filename');
      }  catch (e) {
        file = await tempFile.copy('$path/$filename');
      }
      setState(() {
        documents.add(file);
        fileAdded++;
        isFileThere = true;
      });

      List<String> tempDoc = [];
      for (int i = 0; i < documents.length; i++) {
        tempDoc.add(documents[i].path);
      }

      await SharedPrefUtils.saveStrList('files', tempDoc);
      await SharedPrefUtils.saveStrList('titles', titleList);
      Navigator.of(context, rootNavigator: true).pop();
    }
    else{
      titleList.removeLast();
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
      title: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.cancel,
                  size: 25,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          Text('Document Details',
              style: font.copyWith(color: primaryColor, fontSize: 24)),
          Divider(
            color: primaryColor,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
      contentTextStyle: font.copyWith(color: primaryColor, fontSize: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
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
          onPressed: () async {
            if (docTitle == '' || docTitle == null) {
              doToast('Please enter a title for your document');
              return;
            }
            else if(titleList.contains(docTitle)){
              doToast('Your $docTitle was already added');
            }
            else {
              setState(() {
                titleList.add(docTitle);
              });
              addCamDocs(context);
            }
          },
          child: Text(
            'Camera',
            style: font.copyWith(color: primaryColor, fontSize: 20),
          ),
        ),
        FlatButton(
          onPressed: () async {
            if (docTitle == '' || docTitle == null) {
              doToast('Please enter a title for your document');
              return;
            }
            else if(titleList.contains(docTitle)){
              doToast('$docTitle was already added');
            }
            else {
              setState(() {
                titleList.add(docTitle);
              });
              addDocs(context);
            }
          },
          child: Text('Gallery',
              style: font.copyWith(color: primaryColor, fontSize: 20)),
        ),
      ],
    );
  }
}
